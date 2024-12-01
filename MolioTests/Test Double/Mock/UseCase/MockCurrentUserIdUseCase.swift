@testable import Molio

final class MockCurrentUserIdUseCase: CurrentUserIdUseCase {
    var userIDToReturn: String?
    func execute() throws -> String? {
        userIDToReturn
    }
}
