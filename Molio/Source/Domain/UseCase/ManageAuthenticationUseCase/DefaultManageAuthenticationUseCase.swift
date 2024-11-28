struct DefaultManageAuthenticationUseCase: ManageAuthenticationUseCase {
    private let authStateRepository: AuthStateRepository
    
    init(authStateRepository: AuthStateRepository = DIContainer.shared.resolve()) {
        self.authStateRepository = authStateRepository
    }
    
    func isAuthModeSelected() -> Bool {
        return authStateRepository.authSelection == .selected
    }
    
    func setAuthMode(_ mode: AuthMode) {
        authStateRepository.setAuthMode(mode)
        setAuthSelection(.selected)
    }
    
    func isLogin() -> Bool {
        switch authStateRepository.authMode {
        case .authenticated:
            return true
        case .guest:
            return false
        }
    }
    
    private func setAuthSelection(_ selection: AuthSelection) {
        authStateRepository.setAuthSelection(selection)
    }
}
