import Combine

final class DefaultPublishAllMusicInCurrentPlaylistUseCase: PublishAllMusicInCurrentPlaylistUseCase {
    
    private let allMusicPublisher: AnyPublisher<[MolioMusic], Never>
    
    init(
        publishCurrentPlaylistUseCase: any PublishCurrentPlaylistUseCase = DIContainer.shared.resolve(),
        musicKitService: any MusicKitService = DIContainer.shared.resolve()
    ) {
        let publisher = publishCurrentPlaylistUseCase
            .execute()
            .flatMap { molioPlaylist in
                return Future<[MolioMusic], Never> { promise in
                    guard let musicISRCs = molioPlaylist?.musicISRCs else {
                        return promise(.success([]))
                    }

                    Task {
                        let molioMusics = await musicKitService.getMusic(with: musicISRCs)

                        return promise(.success(molioMusics))
                    }
                }
            }
            .eraseToAnyPublisher()
        
        self.allMusicPublisher = publisher
    }
    
    func execute() -> AnyPublisher<[MolioMusic], Never> {
        allMusicPublisher
    }
}
