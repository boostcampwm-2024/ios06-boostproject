import Combine
import Foundation
@testable import Molio

final class MockPlaylistRepository: PlaylistRepository {
    var mockPlaylist: [MolioPlaylist] = []
    var willThrowError: Bool = false
    
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> {
        return Just(mockPlaylist).eraseToAnyPublisher()
    }
    
    func addMusic(isrc: String, to playlistName: String) {}
    
    func deleteMusic(isrc: String, in playlistName: String) {}
    
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {}
    
    func saveNewPlaylist(_ playlistName: String) async throws -> UUID {
        guard !willThrowError else { throw CoreDataError.saveFailed }
        return UUID()
    }
    
    func deletePlaylist(_ playlistName: String) {}
    
    func fetchPlaylists() -> [MolioPlaylist]? {
        []
    }
    
    func fetchPlaylist(for name: String) -> MolioPlaylist? {
        MolioPlaylist(id: UUID(), name: name, createdAt: Date.now, musicISRCs: [], filter: MusicFilter(genres: []))
    }
    
    func updatePlaylist(id: UUID, to newValue: Molio.MolioPlaylist) async throws {
        guard !willThrowError else { throw CoreDataError.updateFailed }
    }
}
