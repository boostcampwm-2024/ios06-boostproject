import Foundation
import Combine

protocol RealPlaylistRepository {
    func addMusic(userID: String?, isrc: String, to playlistID: UUID) async throws
    func deleteMusic(userID: String?, isrc: String, in playlistID: UUID) async throws
    func moveMusic(userID: String?, isrc: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws
    func createNewPlaylist(userID: String?, playlistID: UUID, _ playlistName: String) async throws
    func deletePlaylist(userID: String?, _ playlistID: UUID) async throws
    func fetchPlaylists(userID: String?) async throws -> [MolioPlaylist]?
    func fetchPlaylist(userID: String?, for playlistID: UUID) async throws -> MolioPlaylist?
    func updatePlaylist(userID: String?, newPlaylist: MolioPlaylist) async throws
}
