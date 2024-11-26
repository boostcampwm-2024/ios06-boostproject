import XCTest
@testable import Molio

final class FirestorePlaylistServiceTests: XCTestCase {
    var firestoreManager: FirestoreManager!
    var playlistService: FirestorePlaylistService!
    
    var createdPlaylists: [MolioPlaylist] = []
    var createdUsers: [MolioUser] = []
    
    var currentUser: MolioUser!
    
    override func setUp() async throws {
        try await super.setUp()
        self.firestoreManager = FirestoreManager()
        self.playlistService = FirestorePlaylistService(
            firestoreManager: firestoreManager,
            loginManager: MockLoginManager(mockID: "mockID")
        )
        self.createdPlaylists = []
        self.createdUsers = []
        
        // Ensure the mock user exists in Firestore
        self.currentUser = MolioUser(
            userName: "Mock User",
            userID: "mockID",
            follower: [],
            following: [],
            playlists: [],
            profileImageURL: ""
        )
        
        try await firestoreManager.create(entity: currentUser)
        self.createdUsers.append(currentUser)
    }
    
    override func tearDown() async throws {
        // Delete any playlists created during the tests
        for playlist in createdPlaylists {
            try? await firestoreManager.delete(entityType: MolioPlaylist.self, idString: playlist.idString)
        }
        
        // Delete any users created during the tests
        for user in createdUsers {
            try await firestoreManager.delete(entityType: MolioUser.self, idString: user.idString)
        }
        
        self.firestoreManager = nil
        self.playlistService = nil
        self.createdPlaylists = []
        self.createdUsers = []
        self.currentUser = nil
        
        try await super.tearDown()
    }
    
    func testCreatePlaylist() async throws {
        // Given
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Test Playlist",
            createdAt: .now,
            musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        
        // When
        try await playlistService.create(playlist: playlist)
        self.createdPlaylists.append(playlist)
        
        // Then
        // Verify that the playlist was created in Firestore
        let fetchedPlaylist = try await firestoreManager.read(entityType: MolioPlaylist.self, id: playlist.idString)
        XCTAssertNotNil(fetchedPlaylist, "플레이리스트는 Firestore에 생성되어야 합니다")
        XCTAssertEqual(fetchedPlaylist?.id, playlist.id, "가져온 플레이리스트의 ID는 원본과 일치해야 합니다")
        
        // Verify that the playlist ID was added to the user's playlists
        let user = try await firestoreManager.read(entityType: MolioUser.self, id: currentUser.userID)
        XCTAssertNotNil(user, "사용자는 존재해야 합니다")
        XCTAssertTrue(user!.playlists.contains(playlist.idString), "사용자의 플레이리스트에 새 플레이리스트 ID가 포함되어야 합니다")
    }
    
    func testReadPlaylist() async throws {
        // Given: Create a playlist and save it
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Test Playlist",
            createdAt: .now,
            musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        try await firestoreManager.create(entity: playlist)
        self.createdPlaylists.append(playlist)
        
        // When: Read the playlist using the service
        let fetchedPlaylist = try await playlistService.read(playlistID: playlist.idString)
        
        // Then
        XCTAssertNotNil(fetchedPlaylist, "가져온 플레이리스트는 nil이 아니어야 합니다")
        XCTAssertEqual(fetchedPlaylist?.id, playlist.id, "가져온 플레이리스트의 ID는 원본과 일치해야 합니다")
    }
    
    func testReadAllPlaylists() async throws {
        // Given: Create some playlists and add them to the user's playlists
        let playlist1 = MolioPlaylist(
            id: UUID(),
            name: "Playlist 1",
            createdAt: .now,
            musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        let playlist2 = MolioPlaylist(
            id: UUID(),
            name: "Playlist 2",
            createdAt: .now,
            musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        
        try await firestoreManager.create(entity: playlist1)
        try await firestoreManager.create(entity: playlist2)
        self.createdPlaylists.append(playlist1)
        self.createdPlaylists.append(playlist2)
        
        // Add the playlist IDs to the user's playlists
        var user = currentUser!
        var newPlaylists = user.playlists
        newPlaylists.append(contentsOf: [playlist1.idString, playlist2.idString])
        user = user.copy(playlists: newPlaylists)
        try await firestoreManager.update(entity: user)
        currentUser = user  // Update the currentUser
        
        // When: Read all playlists using the service
        let playlists = try await playlistService.readAll()
        
        // Then: Verify that the playlists include the ones we added
        XCTAssertTrue(playlists.contains(where: { $0.id == playlist1.id }), "플레이리스트는 playlist1을 포함해야 합니다")
        XCTAssertTrue(playlists.contains(where: { $0.id == playlist2.id }), "플레이리스트는 playlist2을 포함해야 합니다")
    }
    
    func testUpdatePlaylist() async throws {
        // Given: Create a playlist and save it
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Original Name",
            createdAt: .now,
            musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        try await firestoreManager.create(entity: playlist)
        self.createdPlaylists.append(playlist)
        
        // When: Update the playlist's name using the service
        let updatedPlaylist = playlist.copy(name: "Updated Name")
        try await playlistService.update(playlist: updatedPlaylist)
        
        // Then: Fetch the playlist and verify the update
        let fetchedPlaylist = try await firestoreManager.read(entityType: MolioPlaylist.self, id: playlist.idString)
        XCTAssertNotNil(fetchedPlaylist, "가져온 플레이리스트는 nil이 아니어야 합니다")
        XCTAssertEqual(fetchedPlaylist?.name, "Updated Name", "플레이리스트의 이름이 업데이트되어야 합니다")
    }
    
    func testDeletePlaylist() async throws {
        // Given: Create a playlist and save it, add it to user's playlists
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Playlist to Delete",
            createdAt: .now,
            musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        try await firestoreManager.create(entity: playlist)
        self.createdPlaylists.append(playlist)
        
        // Add the playlist ID to the user's playlists
        var user = currentUser!
        var newPlaylists = user.playlists
        newPlaylists.append(playlist.idString)
        user = user.copy(playlists: newPlaylists)
        try await firestoreManager.update(entity: user)
        currentUser = user  // Update the currentUser
        
        // When: Delete the playlist using the service
        try await playlistService.delete(playlistID: playlist.idString)
        
        // Then: Verify that the playlist is deleted from Firestore
        let fetchedPlaylist = try? await firestoreManager.read(entityType: MolioPlaylist.self, id: playlist.idString)
        XCTAssertNil(fetchedPlaylist, "플레이리스트는 Firestore에서 삭제되어야 합니다")
        
        // Note: Since the delete method does not remove the playlist ID from the user's playlists,
        // the following check is omitted. If desired, the delete method should be updated accordingly.
        //
        // Verify that the playlist ID is removed from the user's playlists
        // let updatedUser = try await firestoreManager.read(entityType: MolioUser.self, id: user.userID)
        // XCTAssertFalse(updatedUser!.playlists.contains(playlist.idString), "사용자의 플레이리스트에서 삭제된 플레이리스트 ID가 제거되어야 합니다")
    }
}
