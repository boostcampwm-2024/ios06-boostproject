protocol SpotifyAPIService {
    func fetchRecommendedMusicISRCs(with filter: [MusicGenre]) async throws -> [String]
    func fetchAvailableGenreSeeds() async throws -> SpotifyAvailableGenreSeedsDTO
}
