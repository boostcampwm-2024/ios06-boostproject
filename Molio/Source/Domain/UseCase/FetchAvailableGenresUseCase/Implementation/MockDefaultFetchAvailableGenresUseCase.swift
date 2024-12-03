struct MockFetchAvailableGenresUseCase: FetchAvailableGenresUseCase {
    var musicGenreArrToReturn: [MusicGenre]
    
    init(
        musicGenreArrToReturn: [MusicGenre] = ["Jazz", "K-Pop"]
    ) {
        self.musicGenreArrToReturn = musicGenreArrToReturn
    }
    
    func execute() async throws -> [MusicGenre] {
        return musicGenreArrToReturn
    }
}
