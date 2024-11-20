struct DefaultSignAppleRepository: SignAppleRepository {
    private let firebaseService: FirebaseService
    
    init(firebaseService: FirebaseService) {
        self.firebaseService = firebaseService
    }
    
    func signInApple(info: AppleAuthInfo) async throws {
        return try await firebaseService.signInApple(info: info)
    }
}
