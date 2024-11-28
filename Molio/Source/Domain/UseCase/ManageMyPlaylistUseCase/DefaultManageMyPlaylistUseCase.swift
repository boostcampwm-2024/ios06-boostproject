import Foundation

final class DefaultManageMyPlaylistUseCase:
    ManageMyPlaylistUseCase {
    
    private let currentUserIdUseCase: CurrentUserIdUseCase
    private let repository: RealPlaylistRepository
    
    init(
        currentUserIdUseCase: CurrentUserIdUseCase,
        repository: RealPlaylistRepository
    ) {
        self.currentUserIdUseCase = currentUserIdUseCase
        self.repository = repository
    }
    
    func createPlaylist(playlistName: String) async throws {
        guard let userID = try currentUserIdUseCase.execute() else { return }
        
        let newPlaylistID = UUID()
        try await repository.createNewPlaylist(userID: userID, playlistID: newPlaylistID, playlistName)
    }
    
    func updatePlaylistName(playlistID: String, name: String) async throws {
        try await updatePlaylist(playlistID: playlistID, name: name )
    }

    func updatePlaylistFilter(playlistID: String, filter: MusicFilter) async throws {
        try await updatePlaylist(playlistID: playlistID, filter: filter)
    }
    
    func deletePlaylist(playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute() else { return }
        
        try await repository.deletePlaylist(userID: userID, playlistID)
    }
    
    func addMusic(musicISRC: String, to playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await repository.fetchPlaylist(userID: userID, for: playlistID) else { return }
        
        let newMusicISRCs = playlist.musicISRCs + [musicISRC]
        let newPlaylist = playlist.copy(musicISRCs: newMusicISRCs)
        try await repository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
    
    func deleteMusic(musicISRC: String, from playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await repository.fetchPlaylist(userID: userID, for: playlistID) else { return }
        
        let newMusicISRCs = playlist.musicISRCs.filter { $0 != musicISRC }
        let newPlaylist = playlist.copy(musicISRCs: newMusicISRCs)
        try await repository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
    
    func moveMusic(musicISRC: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {
        if fromIndex == toIndex { return }
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await repository.fetchPlaylist(userID: userID, for: playlistID) else {
            return
        }
        
        guard fromIndex < playlist.musicISRCs.count, toIndex < playlist.musicISRCs.count else {
            throw PlaylistMusicISRCsError.invalidIndex
        }
        
        var updatedMusicISRCs = playlist.musicISRCs
        let movedMusic = updatedMusicISRCs.remove(at: fromIndex)
        
        if fromIndex > toIndex {
            updatedMusicISRCs.insert(movedMusic, at: toIndex)

        } else {
            updatedMusicISRCs.insert(movedMusic, at: toIndex-1)
        }
        
        let updatedPlaylist = playlist.copy(musicISRCs: updatedMusicISRCs)
        
        try await repository.updatePlaylist(userID: userID, newPlaylist: updatedPlaylist)
    }
    
    // MARK: - Private Method
    
    private func updatePlaylist(playlistID: String, name: String? = nil, musicISRCs: [String]? = nil, filter: MusicFilter? = nil, like: [String]? = nil) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlistUUID = UUID(uuidString: playlistID) else { return }
        
        guard let playlist = try await repository.fetchPlaylist(userID: userID, for: playlistUUID) else { return }
        
        let newPlaylist = playlist.copy(name: name, musicISRCs: musicISRCs, filter: filter, like: like)
        try await repository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
}


enum PlaylistMusicISRCsError : Error {
    case invalidIndex
}
