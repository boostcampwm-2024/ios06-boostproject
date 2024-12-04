protocol ManageAuthenticationUseCase {
    func isAuthModeSelected() -> Bool
    func isLogin() -> Bool
    func signInApple(info: AppleAuthInfo) async throws -> (uid: String, isNewUser: Bool)
    func loginGuest()
    func logout() throws
    func deleteAuth(idToken: String, nonce: String, authorizationCode: String) async throws
}
