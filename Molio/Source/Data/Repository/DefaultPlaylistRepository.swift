import Combine
import Foundation

final class DefaultPlaylistRepository: PlaylistRepository {
    private let playlistService: PlaylistLocalStorage
    private let playlistStorage: PlaylistLocalStorage
    
    init(playlistService: PlaylistLocalStorage, playlistStorage: PlaylistLocalStorage) {
        self.playlistService = playlistService
        self.playlistStorage = playlistStorage
    }
    
    func addMusic(userID: String?, isrc: String, to playlistID: UUID) async throws {
        if (userID != nil) {
            
        } else {
            guard let playlist = try await playlistStorage.read(by: playlistID.uuidString) else { return }
            let updatedPlaylist = MolioPlaylist(
                id: playlist.id,
                name: playlist.name,
                createdAt: playlist.createdAt,
                musicISRCs: playlist.musicISRCs + [isrc],
                filter: playlist.filter
            )
            try await playlistStorage.update(updatedPlaylist)
        }
    }
    
    func deleteMusic(userID: String?, isrc: String, in playlistID: UUID) async throws {
        if (userID != nil) {
            
        } else {
            guard let playlist = try await playlistStorage.read(by: playlistID.uuidString) else { return }
            let updatedPlaylist = MolioPlaylist(
                id: playlist.id,
                name: playlist.name,
                createdAt: playlist.createdAt,
                musicISRCs: playlist.musicISRCs.filter{ $0 != isrc },
                filter: playlist.filter
            )
            try await playlistStorage.update(updatedPlaylist)
        }
    }
    
    func moveMusic(userID: String?, isrc: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {
        if (userID != nil) {
            
        } else {
            
        }
    }
    
    func createNewPlaylist(userID: String?, playlistID: UUID, _ playlistName: String) async throws {
        if (userID != nil) {
            
        } else {
            let updatedPlaylist = MolioPlaylist(
                id: playlistID,
                name: playlistName,
                createdAt: Date(),
                musicISRCs: [],
                filter: MusicFilter(genres: [])
            )
            try await playlistStorage.create(updatedPlaylist)
        }
    }
    
    func deletePlaylist(userID: String?, _ playlistID: UUID) async throws {
        if (userID != nil) {
            
        } else {
            try await playlistStorage.delete(by: playlistID.uuidString)
        }
    }
    
    func fetchPlaylists(userID: String?) async throws -> [MolioPlaylist]? {
        if (userID != nil) {
            
        } else {
            return try await playlistStorage.readAll()
        }
        return nil
    }
    
    func fetchPlaylist(userID: String?, for playlistID: UUID) async throws -> MolioPlaylist? {
        if (userID != nil) {
            
        } else {
            return try await playlistStorage.read(by: playlistID.uuidString)
        }
        return nil
    }
    
    func updatePlaylist(userID: String?, newPlaylist: MolioPlaylist) async throws {
        if (userID != nil) {
            
        } else {
            try await playlistStorage.update(newPlaylist)
        }
    }
}
