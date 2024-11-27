import FirebaseAuth

@testable import Molio

final class MockAuthService: AuthService {
    var currentUserID: String = "myUserID"

    func getCurrentUser() async throws -> FirebaseAuth.User {
        throw FirestoreError.documentFetchError
    }
    
    func getCurrentID() -> String {
        return currentUserID

    }
    
    func signInApple(info: Molio.AppleAuthInfo) async throws {
        
    }
    
    func logout() throws {
        
    }
    
    func deleteAccount() async throws {
        
    }
    
    func getMockCurrentUser() async throws -> MockUser {
        return MockUser(
            uid: currentUserID,
            email: "test@example.com",
            displayName: "Test User",
            photoURL: nil
        )
    }
}



struct MockUser {
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
}
