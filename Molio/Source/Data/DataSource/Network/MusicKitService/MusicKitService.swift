protocol MusicKitService {
    func checkSubscriptionStatus() async throws -> Bool
    
    func fetchGenres() async throws -> [MusicGenre]
    func fetchRecommendedMusics(by genres: [MusicGenre]) async throws -> [MolioMusic]
    
    func getMusic(with isrc: String) async -> MolioMusic?
    func getMusic(with isrcs: [String]) async -> [MolioMusic]
    
    func exportAppleMusicPlaylist(name: String, isrcs: [String]) async throws -> String?
}
