protocol ManageAuthenticationUseCase {
    func isAuthModeSelected() -> Bool
    func getAuthMode() -> AuthMode
    func singInApple(info: AppleAuthInfo) async throws
    func loginGuest()
    func logout() throws
    func deleteAuth() async throws
}
