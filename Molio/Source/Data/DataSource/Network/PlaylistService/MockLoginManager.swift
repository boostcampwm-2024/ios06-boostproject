final class MockLoginManager: LoginManager {
    private let mockID: String
    
    init(mockID: String) {
        self.mockID = mockID
    }

    func getCurrentUserID() -> String? {
        return mockID
    }
}
