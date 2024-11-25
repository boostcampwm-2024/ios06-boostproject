import Foundation

struct DefaultUpdatePlaylistUseCase: UpdatePlaylistUseCase {
    private let playlistRepository: PlaylistRepository
    
    init(
        playlistRepository: PlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.playlistRepository = playlistRepository
    }
    
    func execute(of id: UUID, name: String?, filter: MusicFilter?, musicISRCs: [String]?, like: [String]?) async throws {
        print(#fileID, #function)
        try await playlistRepository.updatePlaylist(of: id, name: name, filter: filter, musicISRCs: musicISRCs, like: like)
    }
}
