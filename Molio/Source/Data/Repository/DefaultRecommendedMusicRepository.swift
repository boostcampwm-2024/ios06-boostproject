struct DefaultRecommendedMusicRepository: RecommendedMusicRepository {
    private let musicKitService: MusicKitService
    
    init(
        musicKitService: MusicKitService = DIContainer.shared.resolve()
    ) {
        self.musicKitService = musicKitService
    }
    
    func fetchMusicGenres() async throws -> [MusicGenre] {
        return try await musicKitService.fetchGenres()
    }
    
    func fetchRecommendedMusics(with genres: [MusicGenre]) async throws -> [MolioMusic] {
        return try await musicKitService.fetchRecommendedMusics(by: genres)
    }
}
