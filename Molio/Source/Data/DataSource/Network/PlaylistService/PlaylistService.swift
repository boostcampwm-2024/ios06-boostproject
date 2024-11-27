import Foundation

protocol PlaylistService {
    func createPlaylist(playlist: MolioPlaylistDTO) async throws
    func readPlaylist(playlistID: UUID) async throws -> MolioPlaylistDTO
    func readAllPlaylist(userID: String) async throws -> [MolioPlaylistDTO]
    func updatePlaylist(newPlaylist: MolioPlaylistDTO) async throws
    func deletePlaylist(playlistID: UUID) async throws
}
