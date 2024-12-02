protocol FetchRecommendedMusicUseCase {
    func execute(with filter: MusicFilter) async throws -> [MolioMusic]
}
