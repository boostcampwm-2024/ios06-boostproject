struct DefaultFetchAvailableGenresUseCase: FetchAvailableGenresUseCase {
    private let recommendedMusicRepository: RecommendedMusicRepository
    
    init(
        recommendedMusicRepository: RecommendedMusicRepository = DIContainer.shared.resolve()
    ) {
        self.recommendedMusicRepository = recommendedMusicRepository
    }
    
    func execute() async throws -> [MusicGenre] {
        return try await recommendedMusicRepository.fetchMusicGenres()
    }
}
