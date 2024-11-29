protocol ExportAppleMusicPlaylistUseCase {
    func execute(_ playlist: MolioPlaylist) async throws -> String?
}
