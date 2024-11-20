struct DefaultSignInAppleUseCase: SignInAppleUseCase {
    private let signAppleRepository: SignAppleRepository
    
    init(signAppleRepository: SignAppleRepository) {
        self.signAppleRepository = signAppleRepository
    }
    
    func excute(info: AppleAuthInfo) async throws {
        return try await signAppleRepository.signInApple(info: info)
    }
}
