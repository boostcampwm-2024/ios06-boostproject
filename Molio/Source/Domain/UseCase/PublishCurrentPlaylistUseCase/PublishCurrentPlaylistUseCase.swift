import Combine

protocol PublishCurrentPlaylistUseCase {
    func execute() -> AnyPublisher<MolioPlaylist?, Never>
}
