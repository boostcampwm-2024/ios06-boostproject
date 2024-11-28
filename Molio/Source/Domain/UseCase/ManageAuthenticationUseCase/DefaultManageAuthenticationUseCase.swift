struct DefaultManageAuthenticationUseCase: ManageAuthenticationUseCase {
    private let authStateRepository: AuthStateRepository
    
    init(authStateRepository: AuthStateRepository = DIContainer.shared.resolve()) {
        self.authStateRepository = authStateRepository
    }
    
    func isAuthModeSelected() -> Bool {
        return authStateRepository.authSelection == .selected
    }
    
    func getAuthMode() -> AuthMode {
        return authStateRepository.authMode
    }
    
    func singInApple(info: AppleAuthInfo) async throws {
        try await authStateRepository.signInApple(info: info)
        authStateRepository.setAuthMode(.authenticated)
        authStateRepository.setAuthSelection(.selected)
    }
    
    func loginGuest() {
        authStateRepository.setAuthMode(.guest)
        authStateRepository.setAuthSelection(.selected)
    }
    
    func logout() throws {
        try authStateRepository.logout()
        authStateRepository.setAuthMode(.guest)
    }
    
    func deleteAuth() async throws {
        try await authStateRepository.deleteAuth()
        authStateRepository.setAuthSelection(.unselected)
        authStateRepository.setAuthMode(.guest)
    }
}
