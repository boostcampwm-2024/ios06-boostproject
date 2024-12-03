protocol AppleMusicUseCase {
    func checkSubscription() async throws -> Bool
    func exportPlaylist(_ playlist: MolioPlaylist) async throws -> String?
}
