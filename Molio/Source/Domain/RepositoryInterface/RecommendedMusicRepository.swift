protocol RecommendedMusicRepository {
    /// 넘겨받은 필터에 기반하여 추천된 랜덤 음악 목록을 가져옵니다.
    ///  - Parameters: 추천받을 랜덤 음악에 대한 필터 (플레이리스트 필터)
    ///  - Returns: `RandomMusic`의 배열
    func fetchMusicGenres() async throws -> [MusicGenre]
    func fetchRecommendedMusics(with genres: [MusicGenre]) async throws -> [MolioMusic]
}
