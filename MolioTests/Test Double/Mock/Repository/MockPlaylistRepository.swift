import Combine
import Foundation
@testable import Molio

final class MockRealPlaylistRepository: RealPlaylistRepository {
    var createdPlaylistName: String?
    var createdUserID: String?
    var mockPlaylist: MolioPlaylist?
    var updatedPlaylist: MolioPlaylist?
    var deletedPlaylistID: UUID?
    var playlistsToFetch: [MolioPlaylist]?
    
    var addMusicCalled = false
    var deleteMusicCalled = false
    var moveMusicCalled = false
    var createNewPlaylistCalled = false
    var deletePlaylistCalled = false
    var fetchPlaylistsCalled = false
    var fetchPlaylistCalled = false
    var updatePlaylistCalled = false

    func addMusic(userID: String?, isrc: String, to playlistID: UUID) async throws {
        addMusicCalled = true
    }

    func deleteMusic(userID: String?, isrc: String, in playlistID: UUID) async throws {
        deleteMusicCalled = true
    }

    func moveMusic(userID: String?, isrc: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {
        moveMusicCalled = true
    }

    func createNewPlaylist(userID: String?, playlistID: UUID, _ playlistName: String) async throws {
        createNewPlaylistCalled = true
        createdUserID = userID
        createdPlaylistName = playlistName
    }

    func deletePlaylist(userID: String?, _ playlistID: UUID) async throws {
        deletePlaylistCalled = true
        deletedPlaylistID = playlistID
    }

    func fetchPlaylists(userID: String?) async throws -> [MolioPlaylist]? {
        fetchPlaylistsCalled = true
        return playlistsToFetch
    }

    func fetchPlaylist(userID: String?, for playlistID: UUID) async throws -> MolioPlaylist? {
        fetchPlaylistCalled = true
        return mockPlaylist
    }

    func updatePlaylist(userID: String?, newPlaylist: MolioPlaylist) async throws {
        updatePlaylistCalled = true
        updatedPlaylist = newPlaylist
    }
}
