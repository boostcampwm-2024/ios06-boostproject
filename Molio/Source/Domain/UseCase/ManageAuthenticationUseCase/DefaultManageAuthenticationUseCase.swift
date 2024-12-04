struct DefaultManageAuthenticationUseCase: ManageAuthenticationUseCase {
    private let authStateRepository: AuthStateRepository
    
    init(authStateRepository: AuthStateRepository = DIContainer.shared.resolve()) {
        self.authStateRepository = authStateRepository
    }
    
    func isAuthModeSelected() -> Bool {
        return authStateRepository.authSelection == .selected
    }
    
    func isLogin() -> Bool {
        switch authStateRepository.authMode {
        case .authenticated:
            return true
        case .guest:
            return false
        }
    }
    
    func signInApple(info: AppleAuthInfo) async throws -> (uid: String, isNewUser: Bool) {
        let (uid, isNewUser) = try await authStateRepository.signInApple(info: info)
        authStateRepository.setAuthMode(.authenticated)
        authStateRepository.setAuthSelection(.selected)
        return (uid, isNewUser)
    }
    
    func loginGuest() {
        authStateRepository.setAuthMode(.guest)
        authStateRepository.setAuthSelection(.selected)
    }
    
    func logout() throws {
        try authStateRepository.logout()
        authStateRepository.setAuthMode(.guest)
    }
    
    func deleteAuth(idToken: String, nonce: String, authorizationCode: String) async throws {
        try await authStateRepository.reauthenticateApple(idToken: idToken, nonce: nonce)
        try await authStateRepository.deleteAuth(authorizationCode: authorizationCode)
        authStateRepository.setAuthSelection(.unselected)
        authStateRepository.setAuthMode(.guest)
    }
}
