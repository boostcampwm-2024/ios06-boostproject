struct DefaultCheckAppleMusicSubscriptionUseCase: CheckAppleMusicSubscriptionUseCase {
    private let musicKitService: MusicKitService
    
    init(
        musicKitService: MusicKitService = DIContainer.shared.resolve()
    ) {
        self.musicKitService = musicKitService
    }
    
    func execute() async throws -> Bool {
        try await musicKitService.checkSubscriptionStatus()
    }
}
