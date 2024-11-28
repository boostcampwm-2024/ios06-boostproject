import Foundation

final class DefaultPlaylistUseCase: PlaylistUseCase {
    private let repository: PlaylistRepository
    private let musicService: MusicKitService
    private let authService: AuthService
    private let authRepository: AuthStateRepository
    private var currentUserID: String?
    
    init(
        repository: PlaylistRepository,
        musicService: MusicKitService,
        authService: AuthService,
        authRepository: AuthStateRepository
    ) {
        self.repository = repository
        self.musicService = musicService
        self.authService = authService
        self.authRepository = authRepository
    }
    
    func fetchAllMyPlaylists() async throws -> [MolioPlaylist] {
        await try fetchAuthMode()
        return try await repository.fetchPlaylists(userID: currentUserID)
    }

    func fetchAllFriendPlaylists(userID: String) async throws -> [MolioPlaylist] {
        return try await repository.fetchPlaylists(userID: userID) ?? []
    }
    
    func fetchMyPlaylist(playlistID: UUID) async throws -> MolioPlaylist {
        try await fetchAuthMode()
        return try await repository.fetchPlaylist(userID: currentUserID, for: playlistID) ?? []
    }
    
    func fetchFrinedPlaylist(userID: String, playlistID: UUID) async throws -> MolioPlaylist {
        return try await repository.fetchPlaylist(userID: userID, for: playlistID) ?? []
    }
    
    func fetchAllMyMusics(playlistID: UUID) async throws -> [MolioMusic] {
        let musicISRCs = try await fetchMyPlaylist(playlistID: playlistID).musicISRCs
        return musicISRCs.compactMap { musicISRC in
            await musicService.getMusic(with: musicISRC)
        }
    }
    func fetchAllFriendMusics(userID: String, playlistID: UUID) async throws -> [MolioMusic] {
        let musicIRSCs = try await fetchFrinedPlaylist(userID: userID, playlistID: playlistID).musicISRCs
        return musicIRSCs.compactMap { musicISRC in
            await musicService.getMusic(with: musicISRC)
        }
    }
    
    // About My Playlist
    func addMusic(musicISRC: String, to playlistID: UUID) async throws {
        fetchAuthMode()
        var playlist = try await fetchMyPlaylist(playlistID: playlistID)
        var musicISRCs = playlist.musicISRCs
        
        musicISRCs.append(musicISRC)
        playlist.musicISRCs = musicISRCs
        
        try await repository.updatePlaylist(userID: currentUserID, newPlaylist: playlist)
    }
    
    func deleteMusic(musicISRC: String, from playlistID: UUID) async throws {
        fetchAuthMode()
        var playlist = try await fetchMyPlaylist(playlistID: playlistID)
        let musicISRCs = playlist.musicISRCs.filter { $0 != musicISRC }
        playlist.musicISRCs = musicISRCs
        
        try await repository.updatePlaylist(userID: currentUserID, newPlaylist: playlist)
    }
    
    func moveMusic(musicISRC: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {
        try await repository.moveMusic(userID: currentUserID, isrc: musicISRC, in: playlistID, fromIndex: Int, toIndex: Int)
    }
    
    func createPlaylist(playlistName: String) async throws {
        try await repository.createNewPlaylist(userID: currentUserID, playlistID: UUID(), playlistName)
    }
    
    func updatePlaylistName(playlistID: String, name: String) async throws {
        var playlist = try await fetchMyPlaylist(playlistID: playlistID)
        playlist.title = name
        
        try await repository.updatePlaylist(userID: currentUserID, newPlaylist: playlist)
    }
    
    func updatePlaylistFilter(playlistID: String, filter: MusicFilter) async throws {
        var playlist = try await fetchMyPlaylist(playlistID: playlistID)
        playlist.title = name
        
        try await repository.updatePlaylist(userID: currentUserID, newPlaylist: playlist)
    }
    
    func deletePlaylist(playlistID: UUID) async throws {
        try await fetchAuthMode()
        try await repository.deletePlaylist(userID: currentUserID, playlistID)
    }
    
    func likePlaylist(playlistID: UUID) async throws {
        var playlist = try await fetchMyPlaylist(playlistID: playlistID)
        playlist.likes.append(currentUserID)
        
        try await repository.updatePlaylist(userID: currentUserID, newPlaylist: playlist)
    }
    
    func unlikePlaylist(playlistID: UUID) async throws {
        let playlist = try await fetchMyPlaylist(playlistID: playlistID)
        playlist.likes?.filter{ $0 != currentUserID }
        
        try await repository.updatePlaylist(userID: currentUserID, newPlaylist: playlist)
    }
    
    //MARK: -  private Method
    
    private func fetchAuthMode() async throws {
        let currentAuthMode = authRepository.authMode
        switch currentAuthMode {
        case .authenticated:
            currentUserID = fetchMyUserID()
        case .guest:
            currentUserID = nil
        }
    }
    
    private func fetchMyUserID() throws -> String {
        try authService.getCurrentID()
    }
    
}
