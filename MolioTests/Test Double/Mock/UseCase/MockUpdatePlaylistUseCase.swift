import Foundation
@testable import Molio

final class MockUpdatePlaylistUseCase: UpdatePlaylistUseCase {
    var executedCount: Int = 0
    
    func execute(id: UUID, to updatedPlaylist: Molio.MolioPlaylist) async throws {
        executedCount += 1
    }
}
