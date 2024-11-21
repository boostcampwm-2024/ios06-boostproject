final class DefaultFetchAllPlaylistsUseCase: FetchAllPlaylistsUseCase {
    private let playlistRepository: any PlaylistRepository

    init(
        playlistRepository: any PlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.playlistRepository = playlistRepository
    }
    
    func execute() -> [MolioPlaylist] {
        playlistRepository.fetchPlaylists() ?? []
    }
}
