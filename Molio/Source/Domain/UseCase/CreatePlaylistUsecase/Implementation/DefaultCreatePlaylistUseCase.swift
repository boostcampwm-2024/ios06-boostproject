struct DefaultCreatePlaylistUseCase: CreatePlaylistUseCase {
    private let playlistRepository: PlaylistRepository
    
    init(repository: PlaylistRepository) {
        self.playlistRepository = repository
    }

    func execute(playlistName: String) {
        playlistRepository.saveNewPlaylist(playlistName)
    }
}
