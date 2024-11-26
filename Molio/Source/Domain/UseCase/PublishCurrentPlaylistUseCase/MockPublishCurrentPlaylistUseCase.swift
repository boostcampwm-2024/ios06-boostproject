import Combine
import Foundation

struct MockPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
    var playlistToPublish: MolioPlaylist? = MolioPlaylist.mock
    
    func execute() -> AnyPublisher<MolioPlaylist?, Never> {
        return Just(playlistToPublish).eraseToAnyPublisher()
    }
}
