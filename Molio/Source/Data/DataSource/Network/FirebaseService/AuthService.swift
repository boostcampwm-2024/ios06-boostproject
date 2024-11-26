import FirebaseAuth

protocol AuthService {
    func getCurrentUser() async throws -> User
    func signInApple(info: AppleAuthInfo) async throws
    func logout() throws
    func deleteAccount() async throws
}
