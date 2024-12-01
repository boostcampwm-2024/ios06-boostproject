import Combine
import Foundation

protocol ManageMyPlaylistUseCase {
    // 현재 선택된 플레이리스트
    func currentPlaylistPublisher() -> AnyPublisher<MolioPlaylist?, Never>
    func changeCurrentPlaylist(playlistID: UUID)

    // 플레이리스트 관리
    func createPlaylist(playlistName: String) async throws
    func updatePlaylistName(playlistID: UUID, name: String) async throws
    func updatePlaylistFilter(playlistID: UUID, filter: MusicFilter) async throws
    func deletePlaylist(playlistID: UUID) async throws
    
    // 음악 관리
    func addMusic(musicISRC: String, to playlistID: UUID) async throws
    func deleteMusic(musicISRC: String, from playlistID: UUID) async throws
    func moveMusic(musicISRC: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws
}
