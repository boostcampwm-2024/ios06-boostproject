protocol FetchRecommendedMusicUseCase {
    func execute(with filter: [MusicGenre]) async throws -> [MolioMusic]
}
