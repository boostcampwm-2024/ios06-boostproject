import Foundation

protocol ManageMyPlaylistUseCase {
   // 플레이리스트 관리
    func createPlaylist(playlistName: String) async throws
    func updatePlaylistName(playlistID: String, name: String) async throws
    func updatePlaylistFilter(playlistID: String, filter: MusicFilter) async throws
    func deletePlaylist(playlistID: UUID) async throws
    

    // 음악 관리
    func addMusic(musicISRC: String, to playlistID: UUID) async throws
    func deleteMusic(musicISRC: String, from playlistID: UUID) async throws
    func moveMusic(musicISRC: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws
}
