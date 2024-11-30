import CoreData
import Combine
import Foundation

final class CoreDataPlaylistStorage: PlaylistLocalStorage {
    private let context: NSManagedObjectContext
    private let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    
    typealias Entity = MolioPlaylist
    
    private let alertNotFoundPlaylist: String = "해당 플레이리스트를 못 찾았습니다."
    private let alertNotFoundMusicsinPlaylist: String = "플레이리스트에 음악이 없습니다."
    private let alertFailDeletePlaylist: String = "플레이리스트를 삭제할 수 없습니다"
    
    // MARK: - CRUD Implementation
    
    init (context: NSManagedObjectContext = PersistenceManager.shared.context) {
        self.context = context
        ValueTransformer.setValueTransformer(
            NSSecureUnarchiveFromDataTransformer(),
            forName: NSValueTransformerName("NSSecureUnarchiveFromDataTransformerName")
        )
    }
    
    // Create
    func create(_ entity: MolioPlaylist) async throws {
        try await context.perform {
            let playlist = Playlist(context: self.context)
            
            playlist.id = entity.id
            playlist.name = entity.name
            playlist.createdAt = Date()
            playlist.musicISRCs = entity.musicISRCs
            playlist.filters = entity.filter.genres.map(\.rawValue)
            
            try self.saveContext()
        }
    }
    
    // Read
    func read(by id: String) async throws -> MolioPlaylist? {
        guard let uuid = UUID(uuidString: id) else {
            throw CoreDataError.invalidID
        }
        
        return await withCheckedContinuation { continuation in
            context.perform {
                self.fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
                do {
                    guard let playlist = try self.context.fetch(self.fetchRequest).first else {
                        continuation.resume(returning: nil)
                        return
                    }
                    
                    let filter = MusicFilter(genres: playlist.filters.compactMap { MusicGenre(rawValue: $0) })
                    let molioPlaylist = MolioPlaylist(
                        id: playlist.id,
                        name: playlist.name,
                        createdAt: playlist.createdAt,
                        musicISRCs: playlist.musicISRCs,
                        filter: filter
                    )
                    
                    continuation.resume(returning: molioPlaylist)
                } catch {
                    print("Failed to read playlist: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func readAll() async throws -> [Entity] {
        fetchRequest.predicate = nil
        return try await context.perform {
            let playlists = try self.context.fetch(self.fetchRequest)
            return playlists.map { playlist in
                let filter = MusicFilter(genres: playlist.filters.compactMap { MusicGenre(rawValue: $0) })
                return MolioPlaylist(id: playlist.id,
                              name: playlist.name,
                              createdAt: playlist.createdAt,
                              musicISRCs: playlist.musicISRCs,
                              filter: filter
                )
            }
        }
    }
    
    // Update
    func update(_ entity: MolioPlaylist) async throws {
        try await context.perform {
            self.fetchRequest.predicate = NSPredicate(format: "id == %@", entity.id as CVarArg)
            do {
                guard let playlist = try self.context.fetch(self.fetchRequest).first else {
                    throw CoreDataError.notFound
                }
                playlist.name = entity.name
                playlist.musicISRCs = entity.musicISRCs
                playlist.filters = entity.filter.genres.map(\.rawValue)
                
                try self.saveContext()
            } catch {
                throw CoreDataError.saveFailed
            }
        }
    }
    
    // Delete
    func delete(by id: String) async throws {
        guard let uuid = UUID(uuidString: id) else {
            throw CoreDataError.invalidID
        }
        
        try await context.perform {
            self.fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            do {
                guard let playlist = try self.context.fetch(self.fetchRequest).first else {
                    throw CoreDataError.notFound
                }
                self.context.delete(playlist)
                try self.saveContext()
            } catch {
                throw CoreDataError.saveFailed
            }
        }
    }
    
    // MARK: - Private Method
    
    private func saveContext() throws {
        try PersistenceManager.shared.saveContext()
    }
}

// 수정하기 전의 레포지토리입니다. 삭제하면 빌드가 되지 않아 Mock을 붙여 살려두었습니다.
// TODO: UseCase 다 작성되고 연결되면 삭제합니다.
final class MockPlaylistRepository: PlaylistRepository {
    private let context: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    private let playlistsSubject = PassthroughSubject <[MolioPlaylist], Never>()
    private let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
    
    private let alertNotFoundPlaylist: String = "해당 플레이리스트를 못 찾았습니다."
    private let alertNotFoundMusicsinPlaylist: String = "플레이리스트에 음악이 없습니다."
    private let alertFailDeletePlaylist: String = "플레이리스트를 삭제할 수 없습니다"
    private let alertFailUpdatePlaylist: String = "플레이리스트를 업데이트할 수 없습니다"
    
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
    
    func addMusic(isrc: String, to playlistID: UUID) async throws {
        fetchRequest.predicate = NSPredicate(format: "id == %@", playlistID as CVarArg)
        
        do {
            let playlists = try context.fetch(fetchRequest)
            guard let playlistToAdd = playlists.first else {
                showAlert(alertNotFoundPlaylist)
                throw CoreDataError.updateFailed
            }
            playlistToAdd.musicISRCs.append(isrc)
            try context.save()
        } catch {
            showAlert(alertFailUpdatePlaylist)
            throw CoreDataError.updateFailed
        }
    }
    
    func deleteMusic(isrc: String, in playlistName: String) {
        guard let playlist = fetchRawPlaylist(for: playlistName) else { return }
        
        playlist.musicISRCs.removeAll { $0 == isrc }
    }
    
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {
        guard let playlist = fetchRawPlaylist(for: playlistName),
              playlist.musicISRCs.indices.contains(fromIndex),
              playlist.musicISRCs.indices.contains(toIndex) else { return }
        
        if playlist.musicISRCs[fromIndex] == isrc {
            let musicToMove = playlist.musicISRCs.remove(at: fromIndex)
            playlist.musicISRCs.insert(musicToMove, at: toIndex)
            
        }
    }
    
    func fetchPlaylists() -> [MolioPlaylist]? {
        do {
            fetchRequest.predicate = nil // 조건 없이 모든 데이터를 가져옴
            let playlists = try context.fetch(fetchRequest)
            
            let molioPlaylists = playlists.map { playlist in
                let filter = MusicFilter(genres: playlist.filters.compactMap { MusicGenre(rawValue: $0) })
                return MolioPlaylist(
                    id: playlist.id,
                    name: playlist.name,
                    createdAt: playlist.createdAt,
                    musicISRCs: playlist.musicISRCs,
                    filter: filter
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
                    
                    let filter = MusicFilter(genres: playlist.filters.compactMap { MusicGenre(rawValue: $0) })
                    let molioPlaylist = MolioPlaylist(
                        id: playlist.id,
                        name: playlist.name,
                        createdAt: playlist.createdAt,
                        musicISRCs: playlist.musicISRCs,
                        filter: filter
                    )
                    continuation.resume(returning: molioPlaylist)
                } catch {
                    print("Failed to fetch playlist: \(error)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    /// 플레이리스트 정보 업데이트
    func updatePlaylist(
        of id: UUID,
        name: String?,
        filter: MusicFilter?,
        musicISRCs: [String]?,
        like: [String]?
    ) async throws {
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let playlists = try context.fetch(fetchRequest)
            guard let playlistToUpdate = playlists.first else {
                showAlert(alertNotFoundPlaylist)
                throw CoreDataError.updateFailed
            }
            
            if let name = name {
                playlistToUpdate.name = name
            }
            if let filter = filter {
                playlistToUpdate.filters = filter.genres.map(\.rawValue)
            }
            if let musicISRCs = musicISRCs {
                playlistToUpdate.filters = musicISRCs
            }
            // TODO: - 좋아요 업데이트
            
            try context.save()
        } catch {
            showAlert(alertFailUpdatePlaylist)
            throw CoreDataError.updateFailed
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
