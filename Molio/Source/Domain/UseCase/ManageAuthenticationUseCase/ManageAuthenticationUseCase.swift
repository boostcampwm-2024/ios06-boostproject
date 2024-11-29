protocol ManageAuthenticationUseCase {
    func isAuthModeSelected() -> Bool
    func isLogin() -> Bool
    func singInApple(info: AppleAuthInfo) async throws
    func loginGuest()
    func logout() throws
    func deleteAuth(idToken: String, nonce: String, authorizationCode: String) async throws
}
