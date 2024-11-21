import Combine

final class DefaultPublishAllPlaylistTitleUseCase: PublishAllPlaylistTitleUseCase {
    private var subsciptions: Set<AnyCancellable> = []
    
    private let allPlaylistTitlePublisher: AnyPublisher<[String], Never>
    
    init(
        playlistRepository: any PlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.allPlaylistTitlePublisher = playlistRepository.playlistsPublisher
            .flatMap { playlist in
                Just(playlist.map { $0.name })
            }
            .eraseToAnyPublisher()
    }
    
    func execute() -> AnyPublisher<[String], Never> {
        allPlaylistTitlePublisher
    }
}
