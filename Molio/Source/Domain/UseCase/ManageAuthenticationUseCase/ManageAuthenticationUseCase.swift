protocol ManageAuthenticationUseCase {
    func isAuthModeSelected() -> Bool
    func setAuthMode(_ mode: AuthMode)
}
