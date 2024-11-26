import Foundation
import Combine

protocol PlaylistRepository {
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> { get }
    
    func addMusic(isrc: String, to playlistName: String)
    func deleteMusic(isrc: String, in playlistName: String)
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int)

    func saveNewPlaylist(_ playlistName: String) async throws -> UUID
    func deletePlaylist(_ playlistName: String)
    func fetchPlaylists() -> [MolioPlaylist]?
    func fetchPlaylist(for id: String) async throws -> MolioPlaylist?
    func updatePlaylist(of id: UUID, name: String?, filter: MusicFilter?, musicISRCs: [String]?, like: [String]?) async throws
}
