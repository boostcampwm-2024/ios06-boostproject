import Combine

protocol PublishAllPlaylistTitleUseCase {
    func execute() -> AnyPublisher<[String], Never>
}
