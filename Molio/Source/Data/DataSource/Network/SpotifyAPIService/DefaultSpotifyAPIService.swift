struct DefaultSpotifyAPIService: SpotifyAPIService {
    private let networkProvider: NetworkProvider
    private let tokenProvider: SpotifyTokenProvider
    
    init(
        networkProvider: NetworkProvider = DIContainer.shared.resolve(),
        tokenProvider: SpotifyTokenProvider = DIContainer.shared.resolve()
    ) {
        self.networkProvider = networkProvider
        self.tokenProvider = tokenProvider
    }
    
    func fetchRecommendedMusicISRCs(with filter: MusicFilter) async throws -> [String] {
        let accessToken = try await tokenProvider.getAccessToken()
        let genresParam = filter.genres.map(\.rawValue) // TODO: - 장르 5개씩 쪼개서 요청 보내기
        let endPoint = SpotifyAPI.getRecommendations(genres: genresParam, accessToken: accessToken)
        let dto: RecommendationsResponseDTO = try await networkProvider.request(endPoint)
        return dto.tracks.map(\.externalIDs.isrc)
    }
    
    func fetchAvailableGenreSeeds() async throws -> SpotifyAvailableGenreSeedsDTO {
        let accessToken = try await tokenProvider.getAccessToken()
        let endPoint = SpotifyAPI.getAvailableGenreSeeds(accessToken: accessToken)
        let dto: SpotifyAvailableGenreSeedsDTO = try await networkProvider.request(endPoint)
        return dto
    }
}
