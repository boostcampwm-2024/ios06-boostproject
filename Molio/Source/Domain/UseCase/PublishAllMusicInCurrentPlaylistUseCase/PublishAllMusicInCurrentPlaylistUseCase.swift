import Combine

protocol PublishAllMusicInCurrentPlaylistUseCase {
    func execute() -> AnyPublisher<[MolioMusic], Never>
}
