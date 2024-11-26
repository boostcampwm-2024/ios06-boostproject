protocol PlaylistLocalStorage {
    func create(_ entity: MolioPlaylist) async throws
    func read(by id: String) async throws -> MolioPlaylist?
    func readAll() async throws -> [MolioPlaylist]
    func update(_ entity: MolioPlaylist) async throws
    func delete(by id: String) async throws
}
