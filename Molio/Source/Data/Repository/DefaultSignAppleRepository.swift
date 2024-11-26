struct DefaultSignAppleRepository: SignAppleRepository {
    private let firebaseService: AuthService
    
    init(firebaseService: AuthService = DIContainer.shared.resolve()) {
        self.firebaseService = firebaseService
    }
    
    func signInApple(info: AppleAuthInfo) async throws {
        return try await firebaseService.signInApple(info: info)
    }
}
