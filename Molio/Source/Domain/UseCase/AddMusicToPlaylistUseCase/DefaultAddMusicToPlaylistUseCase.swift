import Foundation

struct DefaultAddMusicToPlaylistUseCase: AddMusicToPlaylistUseCase {
    private let playlistRepository: PlaylistRepository
    
    init(
        playlistRepository: PlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.playlistRepository = playlistRepository
    }
    
    func execute(isrc: String, to playlistID: UUID) async throws {
        try await playlistRepository.addMusic(isrc: isrc, to: playlistID)
    }
}
