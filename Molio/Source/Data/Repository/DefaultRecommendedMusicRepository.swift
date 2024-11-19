struct DefaultRecommendedMusicRepository: RecommendedMusicRepository {
    private let spotifyAPIService: SpotifyAPIService
    private let musicKitService: MusicKitService
    
    init(spotifyAPIService: SpotifyAPIService,
         musicKitService: MusicKitService
    ) {
        self.spotifyAPIService = spotifyAPIService
        self.musicKitService = musicKitService
    }
    
    func fetchMusics(genres: [String]) async throws -> [RandomMusic] {
        let musicFilter = MusicFilter(genres: genres)
        let isrcs = try await spotifyAPIService.fetchRecommendedMusicISRCs(musicFilter: musicFilter)

        // TODO: 이걸 [ISRC]반환으로 바꾸고 ParallelMusicFetchForISRCsUseCase에서 그걸 처리하도록 수정하기
        return try await withThrowingTaskGroup(of: RandomMusic?.self) { group in
            var musics: [RandomMusic] = []
            for isrc in isrcs {
                group.addTask {
                    return await musicKitService.getMusic(with: isrc)
                }
            }
            
            for try await music in group {
                if let music {
                    musics.append(music)
                }
            }
            
            return musics
        }
    }
}
