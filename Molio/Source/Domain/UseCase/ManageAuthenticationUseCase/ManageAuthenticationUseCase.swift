protocol ManageAuthenticationUseCase {
    func isAuthModeSelected() -> Bool
    func getAuthMode() -> AuthMode
    func setAuthMode(_ mode: AuthMode)
}
