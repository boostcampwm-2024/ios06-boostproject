protocol FetchAllPlaylistsUseCase {
    func execute() async -> [MolioPlaylist] 
}
