protocol PlaylistService {
    func create(playlist: MolioPlaylist) async throws
    func read(playlistID: String) async throws -> MolioPlaylist?
    func readAll() async throws -> [MolioPlaylist]
    func delete(playlistID: String) async throws
    func update(playlist: MolioPlaylist) async throws
}
