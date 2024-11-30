import XCTest
import FirebaseAuth
@testable import Molio

final class DefaultCurrentUserIdUseCaseTests: XCTestCase {
    
    class MockAuthService: AuthService {
        func getCurrentUser() async throws -> FirebaseAuth.User {
            throw FirestoreError.documentFetchError
        }
        
        func signInApple(info: Molio.AppleAuthInfo) async throws {
            
        }
        
        func logout() throws {
            
        }
        
        func reauthenticateApple(idToken: String, nonce: String) async throws {
            
        }
        
        func deleteAccount(authorizationCode: String) async throws {
            
        }
        
        var currentID: String?
        
        func getCurrentID() -> String {
            return currentID ?? ""
        }
    }
    
    class MockManageAuthenticationUseCase: ManageAuthenticationUseCase {
        func isAuthModeSelected() -> Bool {
            return true
        }
        
        var isLoggedIn: Bool = false
        
        func isLogin() -> Bool {
            return isLoggedIn
        }
        
        func singInApple(info: AppleAuthInfo) async throws {
            
        }
        
        func loginGuest() {
            
        }
        
        func logout() throws {
            
        }
        
        func deleteAuth(idToken: String, nonce: String, authorizationCode: String) async throws {
            
        }
    }
    
    func testExecute_WhenLoggedIn_ReturnsCurrentUserID() throws {
        let mockAuthService = MockAuthService()
        let mockUseCase = MockManageAuthenticationUseCase()
        mockAuthService.currentID = "mockUserID"
        mockUseCase.isLoggedIn = true
        
        let useCase = DefaultCurrentUserIdUseCase(
            authService: mockAuthService,
            usecase: mockUseCase
        )
        
        let result = try useCase.execute()
        
        XCTAssertEqual(result, "mockUserID", "로그인했을 때에는 아이디를 리턴합니다.")
    }
    
    func testExecute_WhenNotLoggedIn_ReturnsNil() throws {
        let mockAuthService = MockAuthService()
        let mockUseCase = MockManageAuthenticationUseCase()
        mockUseCase.isLoggedIn = false
        
        let useCase = DefaultCurrentUserIdUseCase(
            authService: mockAuthService,
            usecase: mockUseCase
        )
        
        let result = try useCase.execute()
        
        XCTAssertNil(result, "로그인을 하지 않았을 때에는 Nil을 리턴합니다.")
    }
}
