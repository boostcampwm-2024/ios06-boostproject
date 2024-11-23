import Foundation
import CoreData
import Combine

final class DefaultPlaylistRepository: PlaylistRepository {
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    private let playlistsSubject = PassthroughSubject <[MolioPlaylist], Never>()
    private let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    
    private let alertNotFoundPlaylist: String = "해당 플레이리스트를 못 찾았습니다."
    private let alertNotFoundMusicsinPlaylist: String = "플레이리스트에 음악이 없습니다."
    private let alertFailDeletePlaylist: String = "플레이리스트를 삭제할 수 없습니다"
    
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> {
        playlistsSubject.eraseToAnyPublisher()
    }
    
    init() {
        context = PersistenceManager.shared.context
    }
    
    init (context: NSManagedObjectContext) {
        self.context = context
        
        ValueTransformer.setValueTransformer(
            NSSecureUnarchiveFromDataTransformer(),
            forName: NSValueTransformerName("NSSecureUnarchiveFromDataTransformerName")
        )
        setupChangeObserver()
    }
    
    func addMusic(isrc: String, to playlistName: String) {
        guard let playlist = fetchRawPlaylist(for: playlistName) else { return }
        
        playlist.musicISRCs.append(isrc)
        saveContext()
    }
    
    func deleteMusic(isrc: String, in playlistName: String) {
        guard let playlist = fetchRawPlaylist(for: playlistName) else { return }
        
        playlist.musicISRCs.removeAll { $0 == isrc }
        saveContext()
    }
    
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {
        guard let playlist = fetchRawPlaylist(for: playlistName),
              playlist.musicISRCs.indices.contains(fromIndex),
              playlist.musicISRCs.indices.contains(toIndex) else { return }
        
        if playlist.musicISRCs[fromIndex] == isrc {
            let musicToMove = playlist.musicISRCs.remove(at: fromIndex)
            playlist.musicISRCs.insert(musicToMove, at: toIndex)
            
            saveContext()
        }
    }
    
    func fetchPlaylists() -> [MolioPlaylist]? {
        do {
            fetchRequest.predicate = nil // 조건 없이 모든 데이터를 가져옴
            let playlists = try context.fetch(fetchRequest)

            let molioPlaylists = playlists.map { playlist in
                MolioPlaylist(
                    id: playlist.id,
                    name: playlist.name,
                    createdAt: playlist.createdAt,
                    musicISRCs: playlist.musicISRCs,
                    filters: playlist.filters
                )
            }

            return molioPlaylists
        } catch {
            print("Failed to fetch playlists: \(error)")
            return nil
        }
    }
    
    func saveNewPlaylist(_ playlistName: String) async throws -> UUID {
        try await context.perform { [weak self] in
            guard let self = self else {
                throw CoreDataError.contextUnavailable
            }
            let newId = UUID()
            let playlist = Playlist(context: self.context)
            playlist.id = newId
            playlist.name = playlistName
            playlist.createdAt = Date()
            playlist.musicISRCs = []
            playlist.filters = []
            
            try saveContexts()
            return newId
        }
    }
    
    func deletePlaylist(_ playlistName: String) {
        guard let playlist = fetchRawPlaylist(for: playlistName) else { return }
        
        context.delete(playlist)
        saveContext()
    }
    
    func fetchPlaylist(for id: String) async -> MolioPlaylist? {
        await withCheckedContinuation { continuation in
            context.perform {
                self.fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                self.fetchRequest.returnsObjectsAsFaults = false
                do {
                    guard let playlist = try self.context.fetch(self.fetchRequest).first else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    let molioPlaylist = MolioPlaylist(
                        id: playlist.id,
                        name: playlist.name,
                        createdAt: playlist.createdAt,
                        musicISRCs: playlist.musicISRCs,
                        filters: playlist.filters
                    )
                    continuation.resume(returning: molioPlaylist)
                } catch {
                    print("Failed to fetch playlist: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    // MARK: - Private Method
    
    private func setupChangeObserver() {
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self]_ in
                self?.fetchPlaylistsAndUpdate()
            }
            .store(in: &cancellables)
    }
    
    private func fetchPlaylistsAndUpdate() {
        guard let playlists = fetchPlaylists() else { return }
        playlistsSubject.send(playlists)
    }
    
    /// 현재 데이터 저장하기
    private func saveContext() {
        PersistenceManager.shared.saveContext()
    }
    
    private func saveContexts() throws {
        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
        
    }
    
    private func fetchPlaylist(id: UUID) -> Playlist? {
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let playlists = try context.fetch(fetchRequest)
            return playlists.first
        } catch {
            showAlert(alertNotFoundPlaylist)
            return nil
        }
    }
    
    private func fetchRawPlaylist(for name: String) -> Playlist? {
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        do {
            let playlists = try context.fetch(fetchRequest)
            return playlists.first
        } catch {
            print("Failed to fetch playlist: \(error)")
            return nil
        }
    }
    
    // TODO: 알림창 추가
    private func showAlert(_ context: String) {
        print(context)
    }
}
