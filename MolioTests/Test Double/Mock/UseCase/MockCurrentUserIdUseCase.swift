@testable import Molio

struct MockCurrentUserIdUseCase: CurrentUserIdUseCase {
    var userIDToReturn: String?
    func execute() throws -> String? {
        userIDToReturn
    }
}
