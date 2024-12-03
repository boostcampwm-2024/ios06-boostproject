protocol MusicKitService {
    func checkAuthorizationStatus() async throws
    func checkSubscriptionStatus() async throws -> Bool
    
    func fetchGenres() async throws -> [MusicGenre]
    func fetchRecommendedMusics(by genres: [MusicGenre]) async throws -> [MolioMusic]
    
    func getMusic(with isrcs: [String]) async throws -> [MolioMusic]
    
    func exportAppleMusicPlaylist(name: String, isrcs: [String]) async throws -> String?
}
