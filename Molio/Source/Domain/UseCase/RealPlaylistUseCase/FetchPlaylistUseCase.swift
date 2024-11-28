import Foundation

protocol FetchPlaylistUseCase {
    func fetchMyAllPlaylists() async throws -> [MolioPlaylist]
    func fetchMyPlaylist(playlistID: UUID) async throws -> MolioPlaylist
    func fetchAllMusicIn(playlistID: UUID) async throws -> [MolioMusic]
    
    func fetchFriendAllPlaylists(friendUserID: String) async throws -> [MolioPlaylist]
    func fetchFriendPlaylist(friendUserID: String, playlistID: UUID) async throws -> MolioPlaylist
    func fetchAllFriendMusics(friendUserID: String, playlistID: UUID) async throws -> [MolioMusic]
}
