struct DefaultFetchRecommendedMusicUseCase: FetchRecommendedMusicUseCase {
    private let musicRepository: RecommendedMusicRepository
    
    init(
        repository: RecommendedMusicRepository = DIContainer.shared.resolve()
    ) {
        self.musicRepository = repository
    }
    
    func execute(with filter: [MusicGenre]) async throws -> [MolioMusic] {
        return try await musicRepository.fetchRecommendedMusics(with: filter)
    }
}
