struct DefaultRecommendedMusicRepository: RecommendedMusicRepository {
    private let spotifyAPIService: SpotifyAPIService
    private let musicKitService: MusicKitService
    
    init(
        spotifyAPIService: SpotifyAPIService = DIContainer.shared.resolve(),
        musicKitService: MusicKitService = DIContainer.shared.resolve()
    ) {
        self.spotifyAPIService = spotifyAPIService
        self.musicKitService = musicKitService
    }
    
    func fetchMusics(with filter: MusicFilter) async throws -> [MolioMusic] {
        let isrcs = try await fetchRecommendedMusicISRCs(with: filter)

        return await musicKitService.getMusic(with: isrcs)
    }
    
    func fetchRecommendedMusicISRCs(with filter: MusicFilter) async throws -> [String] {
        return try await spotifyAPIService.fetchRecommendedMusicISRCs(with: filter)
    }
    
    func fetchMusicGenres() async throws -> [MusicGenre] {
        let availableGenreSeedsDTO = try await spotifyAPIService.fetchAvailableGenreSeeds()
        let musicGenreArr = availableGenreSeedsDTO.genres.compactMap { MusicGenre(rawValue: $0) }
        return musicGenreArr
    }
}
