struct DefaultExportAppleMusicPlaylistUseCase: ExportAppleMusicPlaylistUseCase {
    private let musicKitService: MusicKitService
    
    init(
        musicKitService: MusicKitService = DIContainer.shared.resolve()
    ) {
        self.musicKitService = musicKitService
    }
    
    func execute(_ playlist: MolioPlaylist) async throws -> String? {
        return try await musicKitService.exportAppleMusicPlaylist(name: playlist.name, isrcs: playlist.musicISRCs)
    }
}
