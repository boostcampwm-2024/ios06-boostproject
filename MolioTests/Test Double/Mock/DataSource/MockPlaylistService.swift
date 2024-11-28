import Foundation
@testable import Molio

actor MockPlaylistService: PlaylistService {
    private var playlists: [String: MolioPlaylistDTO] = [:]
    
    func createPlaylist(playlist: MolioPlaylistDTO) async throws {
        if playlists[playlist.id] != nil {
            throw MockFirestoreError.playlistAlreadyExists
        }
        playlists[playlist.id] = playlist
    }
    
    func readPlaylist(playlistID: UUID) async throws -> MolioPlaylistDTO {
        guard let playlist = playlists[playlistID.uuidString] else {
            throw MockFirestoreError.playlistNotFound
        }
        return playlist
    }
    
    func readAllPlaylist(userID: String) async throws -> [MolioPlaylistDTO] {
        return playlists.values.filter { $0.authorID == userID }
    }
    
    func updatePlaylist(newPlaylist: MolioPlaylistDTO) async throws {
        guard playlists[newPlaylist.id] != nil else {
            throw MockFirestoreError.playlistNotFound
        }
        playlists[newPlaylist.id] = newPlaylist
    }
    
    func deletePlaylist(playlistID: UUID) async throws {
        guard playlists.removeValue(forKey: playlistID.uuidString) != nil else {
            throw MockFirestoreError.playlistNotFound
        }
    }
}

enum MockFirestoreError: Error {
    case playlistAlreadyExists
    case playlistNotFound
    case failedToConvertToDictionary
}
