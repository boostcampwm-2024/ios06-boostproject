import Combine
import Foundation
@testable import Molio

final class MockRealPlaylistRepository: RealPlaylistRepository {
    var createPlaylistCalled = false
    var createdPlaylistName: String?
    var createdUserID: String?
    var mockPlaylist: MolioPlaylist?
    var updatePlaylistCalled = false
    var updatedPlaylist: MolioPlaylist?
    var deletePlaylistCalled = false
    var deletedPlaylistID: UUID?

    func addMusic(userID: String?, isrc: String, to playlistID: UUID) async throws {}

    func deleteMusic(userID: String?, isrc: String, in playlistID: UUID) async throws {}

    func moveMusic(userID: String?, isrc: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {}

    func createNewPlaylist(userID: String?, playlistID: UUID, _ playlistName: String) async throws {
        createPlaylistCalled = true
        createdUserID = userID
        createdPlaylistName = playlistName
    }

    func deletePlaylist(userID: String?, _ playlistID: UUID) async throws {
        deletePlaylistCalled = true
        deletedPlaylistID = playlistID
    }

    func fetchPlaylists(userID: String?) async throws -> [MolioPlaylist]? {
        return nil
    }

    func fetchPlaylist(userID: String?, for playlistID: UUID) async throws -> MolioPlaylist? {
        return mockPlaylist
    }

    func updatePlaylist(userID: String?, newPlaylist: MolioPlaylist) async throws {
        updatePlaylistCalled = true
        updatedPlaylist = newPlaylist
    }
}
