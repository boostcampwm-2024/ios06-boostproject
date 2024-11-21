import Combine
import Foundation
@testable import Molio

final class MockCurrentPlaylistRepository: CurrentPlaylistRepository {
    func setDefaultPlaylist(_ id: UUID) throws {}
    
    private var currentPlaylistUUID = CurrentValueSubject<UUID?, Never>(nil)
    
    var currentPlaylistPublisher: AnyPublisher<UUID?, Never> {
        currentPlaylistUUID.eraseToAnyPublisher()
    }
    
    func setCurrentPlaylist(_ id: UUID) {
        currentPlaylistUUID.send(id)
    }
}
