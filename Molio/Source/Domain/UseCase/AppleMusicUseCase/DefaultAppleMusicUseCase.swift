struct DefaultAppleMusicUseCase: AppleMusicUseCase {
    private let musicKitService: MusicKitService
    
    init(
        musicKitService: MusicKitService = DIContainer.shared.resolve()
    ) {
        self.musicKitService = musicKitService
    }
    
    func checkSubscription() async throws -> Bool {
        try await musicKitService.checkSubscriptionStatus()
    }
    
    func exportPlaylist(_ playlist: MolioPlaylist) async throws -> String? {
        return try await musicKitService.exportAppleMusicPlaylist(name: playlist.name, isrcs: playlist.musicISRCs)
    }
}
