import Foundation

struct DefaultUpdatePlaylistUseCase: UpdatePlaylistUseCase {
    private let playlistRepository: PlaylistRepository
    
    init(
        playlistRepository: PlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.playlistRepository = playlistRepository
    }
    
    func execute(id: UUID, to updatedPlaylist: MolioPlaylist) async throws {
        print(#fileID, #function)
        try await playlistRepository.updatePlaylist(id: id, to: updatedPlaylist)
    }
}
