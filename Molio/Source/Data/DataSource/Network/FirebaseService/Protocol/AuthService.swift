import FirebaseAuth

protocol AuthService {
    func getCurrentUser() async throws -> User
    func getCurrentID() throws -> String    
    func signInApple(info: AppleAuthInfo) async throws
    func logout() throws
    func reauthenticateApple(idToken: String, nonce: String) async throws
    func deleteAccount(authorizationCode: String) async throws
}
