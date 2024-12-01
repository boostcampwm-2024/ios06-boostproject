import Foundation

final class DefaultFetchPlaylistUseCase: FetchPlaylistUseCase {
    
    let playlistRepisitory: PlaylistRepository
    let musicKitService: MusicKitService
    let currentUserIDUseCase: CurrentUserIdUseCase
    
    init(
        playlistRepisitory: PlaylistRepository = DIContainer.shared.resolve(),
        musicKitService: MusicKitService = DIContainer.shared.resolve(),
        currentUserIDUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve()
    ) {
        self.playlistRepisitory = playlistRepisitory
        self.musicKitService = musicKitService
        self.currentUserIDUseCase = currentUserIDUseCase
    }
    
    func fetchMyAllPlaylists() async throws -> [MolioPlaylist] {
        let currentUserID = try? currentUserIDUseCase.execute()
        let playlists = try await playlistRepisitory.fetchPlaylists(userID: currentUserID) ?? []
        return playlists
    }
    
    func fetchMyPlaylist(playlistID: UUID) async throws -> MolioPlaylist {
        let currentUserID = try? currentUserIDUseCase.execute()
        
        let playlist = try await playlistRepisitory.fetchPlaylist(userID: currentUserID, for: playlistID)
        
        guard let playlist else {
            throw FetchPlaylistUseCaseError.playlistNotFoundWithID
        }
        
        return playlist
    }
    
    func fetchAllMyMusicIn(playlistID: UUID) async throws -> [MolioMusic] {
        let playlist = try await fetchMyPlaylist(playlistID: playlistID)
        
        let musicsInPlaylist = await musicKitService.getMusic(with: playlist.musicISRCs)
        
        return musicsInPlaylist
    }
    
    func fetchFriendAllPlaylists(friendUserID: String) async throws -> [MolioPlaylist] {
        return  try await playlistRepisitory.fetchPlaylists(userID: friendUserID) ?? []
    }
    
    func fetchFriendPlaylist(friendUserID: String, playlistID: UUID) async throws -> MolioPlaylist {
        let playlist = try await playlistRepisitory.fetchPlaylist(userID: friendUserID, for: playlistID)
        
        guard let playlist else {
            throw FetchPlaylistUseCaseError.playlistNotFoundWithID
        }
        
        return playlist
    }
    
    func fetchAllFriendMusics(friendUserID: String, playlistID: UUID) async throws -> [MolioMusic] {
        let playlist = try await playlistRepisitory.fetchPlaylist(userID: friendUserID, for: playlistID)
        
        guard let playlist else {
            throw FetchPlaylistUseCaseError.playlistNotFoundWithID
        }
        
        let musicsInPlaylist = await musicKitService.getMusic(with: playlist.musicISRCs)

        return musicsInPlaylist
    }
}
