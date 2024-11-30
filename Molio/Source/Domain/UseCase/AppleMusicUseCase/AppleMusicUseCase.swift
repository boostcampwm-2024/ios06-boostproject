protocol AppleMusicUseCase {
    func exportPlaylist(_ playlist: MolioPlaylist) async throws -> String?
    func checkSubscription() async throws -> Bool
}
