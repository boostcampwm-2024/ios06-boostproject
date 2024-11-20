import Combine
import Foundation

protocol CurrentPlaylistRepository {
    var currentPlaylistPublisher: AnyPublisher<UUID?, Never> { get }
    func setCurrentPlaylist(_ id: UUID) throws
    func setDefaultPlaylist(_ id: UUID) throws
}
