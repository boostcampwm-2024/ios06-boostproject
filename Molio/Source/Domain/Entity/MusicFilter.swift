/// 음악 추천을 받기 위한 필터
struct MusicFilter: Decodable {
    /// 선택한 장르 유형들
    var genres: [MusicGenre]
}
