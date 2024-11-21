import Combine
import Foundation
@testable import Molio

final class MockPlaylistRepository: PlaylistRepository {
    private var playlists = CurrentValueSubject<[MolioPlaylist], Never>([])
    
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> {
        playlists.eraseToAnyPublisher()
    }
    
    func addMusic(isrc: String, to playlistName: String) {}
    
    func deleteMusic(isrc: String, in playlistName: String) {}
    
    func deletePlaylist(_ playlistName: String) {}
    
    func fetchPlaylist(for name: String) -> MolioPlaylist? {
        MolioPlaylist(id: UUID(), name: name, createdAt: Date.now, musicISRCs: [], filter: MusicFilter(genres: []))
    }
    
    func fetchPlaylists() -> [MolioPlaylist]? {
        []
    }
    
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {}
    
    func saveNewPlaylist(_ playlistName: String) async throws -> UUID {
        return UUID()
    }
}
