import Combine
import Foundation

final class DefaultPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
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
        currentPlaylistRepository.currentPlaylistPublisher
            .flatMap {  playlistUUID in
                return Future { promise in
                    Task { [weak self] in
                        guard
                            let self,
                            let playlistUUID else {
                            promise(.success(nil))
                            return                         }
                        

                        let playlist = try? await self.playlistRepository.fetchPlaylist(for: playlistUUID.uuidString)
                        
                        promise(.success(playlist))
                    }
                    
                    return
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
