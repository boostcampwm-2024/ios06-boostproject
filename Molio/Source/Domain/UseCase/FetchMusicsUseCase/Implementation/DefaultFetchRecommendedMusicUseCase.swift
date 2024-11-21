struct DefaultFetchRecommendedMusicUseCase: FetchRecommendedMusicUseCase {
    private let musicRepository: RecommendedMusicRepository
    
    init(
        repository: RecommendedMusicRepository = DIContainer.shared.resolve()
    ) {
        self.musicRepository = repository
    }
    
    func execute(with filter: MusicFilter) async throws -> [MolioMusic] {
        return try await musicRepository.fetchMusics(with: filter)
    }
}
