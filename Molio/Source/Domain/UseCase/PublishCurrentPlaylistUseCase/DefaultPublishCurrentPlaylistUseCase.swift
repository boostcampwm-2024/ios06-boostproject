import Combine
import Foundation

// TODO: async 함수 반영
//final class DefaultPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
//    private let playlistRepository: any PlaylistRepository
//    private let currentPlaylistRepository: any CurrentPlaylistRepository
//    
//    init(
//        playlistRepository: any PlaylistRepository = DIContainer.shared.resolve(),
//        currentPlaylistRepository: any CurrentPlaylistRepository = DIContainer.shared.resolve()
//    ) {
//        self.playlistRepository = playlistRepository
//        self.currentPlaylistRepository = currentPlaylistRepository
//    }
//    
//    func execute() -> AnyPublisher<MolioPlaylist?, Never>  {
//        currentPlaylistRepository.currentPlaylistPublisher
//            .flatMap { [weak self] playlistUUID in
//                let molioPlaylist = self?.playlistRepository.fetchPlaylist(for: playlistUUID?.uuidString ?? "")
//                
//                return Just(molioPlaylist).eraseToAnyPublisher()
//            }
//            .eraseToAnyPublisher()
//    }
//}

final class MockPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
    private let playlistRepository: any PlaylistRepository
    private let currentPlaylistRepository: any CurrentPlaylistRepository
    
    init(
        playlistRepository: any PlaylistRepository,
        currentPlaylistRepository: any CurrentPlaylistRepository
    ) {
        self.playlistRepository = playlistRepository
        self.currentPlaylistRepository = currentPlaylistRepository
    }
    
    func execute() -> AnyPublisher<MolioPlaylist?, Never>  {
        let molioPlaylist = MolioPlaylist(id: UUID(), name: "", createdAt: Date(), musicISRCs: [], filters: [])
        return Just(molioPlaylist).eraseToAnyPublisher()
    }
}
