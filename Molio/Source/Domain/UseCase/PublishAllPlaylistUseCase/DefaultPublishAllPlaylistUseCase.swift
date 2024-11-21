import Combine

final class DefaultPublishAllPlaylistUseCase: PublishAllPlaylistUseCase {
    let playlistRepository: any PlaylistRepository
    
    init(
        playlistRepository: any PlaylistRepository = DIContainer.shared.resolve(PlaylistRepository.self)
    ) {
        self.playlistRepository = playlistRepository
    }
    
    func execute() -> AnyPublisher<[MolioPlaylist], Never> {
        self.playlistRepository.playlistsPublisher
    }
}
