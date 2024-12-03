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
            playlist.filters = entity.filter
            
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
                    
                    let molioPlaylist = MolioPlaylist(
                        id: playlist.id,
                        name: playlist.name,
                        createdAt: playlist.createdAt,
                        musicISRCs: playlist.musicISRCs,
                        filter: playlist.filters
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
        return try await context.perform {
            self.fetchRequest.predicate = nil
            let playlists = try self.context.fetch(self.fetchRequest)
            return playlists.map { playlist in
                return MolioPlaylist(
                    id: playlist.id,
                    name: playlist.name,
                    createdAt: playlist.createdAt,
                    musicISRCs: playlist.musicISRCs,
                    filter: playlist.filters
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
                playlist.filters = entity.filter
                
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
