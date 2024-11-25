import Foundation
@testable import Molio

final class MockUpdatePlaylistUseCase: UpdatePlaylistUseCase {
    var executedCount: Int = 0
    
    func execute(of id: UUID, name: String?, filter: MusicFilter?, musicISRCs: [String]?, like: [String]?) async throws {
        executedCount += 1
    }
}
