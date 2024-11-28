import Foundation
@testable import Molio

final class MockPlaylistLocalStorage: PlaylistLocalStorage {
    private var playlists: [UUID: MolioPlaylist] = [:]
    private let queue = DispatchQueue(label: "MockPlaylistLocalStorageQueue", attributes: .concurrent)
    
    // Error Messages
    private let alertNotFoundPlaylist = "해당 플레이리스트를 못 찾았습니다."
    private let alertFailDeletePlaylist = "플레이리스트를 삭제할 수 없습니다"
    
    // Create
    func create(_ entity: MolioPlaylist) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            queue.async(flags: .barrier) {
                if self.playlists[entity.id] != nil {
                    continuation.resume(throwing: CoreDataError.updateFailed)
                } else {
                    self.playlists[entity.id] = entity
                    continuation.resume()
                }
            }
        }
    }
    
    // Read by ID
    func read(by id: String) async throws -> MolioPlaylist? {
        guard let uuid = UUID(uuidString: id) else {
            throw CoreDataError.invalidID
        }
        
        return await withCheckedContinuation { continuation in
            queue.async {
                if let playlist = self.playlists[uuid] {
                    continuation.resume(returning: playlist)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    // Read All
    func readAll() async throws -> [MolioPlaylist] {
        return await withCheckedContinuation { continuation in
            queue.async {
                continuation.resume(returning: Array(self.playlists.values))
            }
        }
    }
    
    // Update
    func update(_ entity: MolioPlaylist) async throws {
        try await withCheckedThrowingContinuation { continuation in
            queue.async(flags: .barrier) {
                if self.playlists[entity.id] != nil {
                    self.playlists[entity.id] = entity
                    continuation.resume()
                } else {
                    self.showAlert(self.alertNotFoundPlaylist)
                    continuation.resume(throwing: CoreDataError.notFound)
                }
            }
        }
    }
    
    // Delete
    func delete(by id: String) async throws {
        guard let uuid = UUID(uuidString: id) else {
            throw CoreDataError.invalidID
        }
        
        try await withCheckedThrowingContinuation { continuation in
            queue.async(flags: .barrier) {
                if self.playlists.removeValue(forKey: uuid) != nil {
                    continuation.resume()
                } else {
                    self.showAlert(self.alertFailDeletePlaylist)
                    continuation.resume(throwing: CoreDataError.saveFailed)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func showAlert(_ message: String) {
        print("Alert: \(message)")
    }
}
