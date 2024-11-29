protocol MusicKitService {
    func checkSubscriptionStatus() async throws -> Bool
    
    func getMusic(with isrc: String) async -> MolioMusic?
    func getMusic(with isrcs: [String]) async -> [MolioMusic]
    
    func exportAppleMusicPlaylist(name: String, isrcs: [String]) async throws
}
