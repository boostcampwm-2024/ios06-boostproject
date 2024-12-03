struct MockFetchAvailableGenresUseCase: FetchAvailableGenresUseCase {
    var musicGenreArrToReturn: [MusicGenre]
    
    init(
        musicGenreArrToReturn: [MusicGenre] = [
            "음악", "얼터너티브", "블루스", "크리스천", "클래식", "컨트리", "댄스",
            "일렉트로닉", "힙합/랩", "홀리데이", "재즈", "K-Pop", "어린이 음악"
        ]
    ) {
        self.musicGenreArrToReturn = musicGenreArrToReturn
    }
    
    func execute() async throws -> [MusicGenre] {
        return musicGenreArrToReturn
    }
}
