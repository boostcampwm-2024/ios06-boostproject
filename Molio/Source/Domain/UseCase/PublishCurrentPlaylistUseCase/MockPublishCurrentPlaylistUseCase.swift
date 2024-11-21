import Combine
import Foundation

struct MockPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
    var playlistToPublish: MolioPlaylist? = MolioPlaylist(
        id: UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!,
        name: "목플레이리스트",
        createdAt: Date(),
        musicISRCs: [],
        filter: MusicFilter(genres: [.pop, .acoustic])
    )
    
    func execute() -> AnyPublisher<MolioPlaylist?, Never> {
        return Just(playlistToPublish).eraseToAnyPublisher()
    }
}
