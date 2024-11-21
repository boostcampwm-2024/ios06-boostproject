import Combine

protocol PublishAllPlaylistUseCase {
    func execute() -> AnyPublisher<[MolioPlaylist], Never>
}
