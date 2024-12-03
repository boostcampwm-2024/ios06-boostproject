import Combine
import Foundation
@testable import Molio

struct MockManagePlaylistUseCase: ManageMyPlaylistUseCase {
    var playlistToReturn: MolioPlaylist?
    
    func currentPlaylistPublisher() -> AnyPublisher<MolioPlaylist?, Never> {
        return Just(playlistToReturn).eraseToAnyPublisher()
    }
    
    func changeCurrentPlaylist(playlistID: UUID) {}
    
    func createPlaylist(playlistName: String) async throws {}
    
    func updatePlaylistName(playlistID: UUID, name: String) async throws {}
    
    func updatePlaylistFilter(playlistID: UUID, filter: [MusicGenre]) async throws {}
    
    func deletePlaylist(playlistID: UUID) async throws {}
    
    func addMusic(musicISRC: String, to playlistID: UUID) async throws {}
    
    func deleteMusic(musicISRC: String, from playlistID: UUID) async throws {}
    
    func moveMusic(musicISRC: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {}
}
