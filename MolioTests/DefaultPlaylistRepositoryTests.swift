import XCTest
import FirebaseCore
import Combine
@testable import Molio

final class DefaultPlaylistRepositoryTests: XCTestCase {
    var repository: DefaultPlaylistRepository!
    var mockService: MockPlaylistService!
    var mockStorage: MockPlaylistLocalStorage!
    
    override func setUp() {
        super.setUp()
        mockService = MockPlaylistService()
        mockStorage = MockPlaylistLocalStorage()
        repository = DefaultPlaylistRepository(
            playlistService: mockService,
            playlistStorage: mockStorage
        )
    }
    
    override func tearDown() {
        repository = nil
        mockService = nil
        mockStorage = nil
        super.tearDown()
    }
    
    // MARK: - 로그인 상태 테스트

    /// 로그인이 된 상태에서 플레이리스트 만들기
    func testAuthenticatedCreatePlaylist() async throws {
        // Given
        let userID = "user123"
        let playlistID = UUID()
        let playlistName = "My Favorite Songs"
        
        // When
        try await repository.createNewPlaylist(userID: userID, playlistID: playlistID, playlistName)
        
        // Then
        let fetchedPlaylistDTO = try await mockService.readPlaylist(playlistID: playlistID)
        XCTAssertEqual(fetchedPlaylistDTO.id, playlistID.uuidString)
        XCTAssertEqual(fetchedPlaylistDTO.authorID, userID)
        XCTAssertEqual(fetchedPlaylistDTO.title, playlistName)
        XCTAssertTrue(fetchedPlaylistDTO.musicISRCs.isEmpty)
    }
    
    /// 로그인이 된 상태에서 플레이리스트 가져오기
    func testAuthenticatedReadPlaylist() async throws {
        // Given
        let userID = "user123"
        let playlistID = UUID()
        let playlistDTO = MolioPlaylistDTO(
            id: playlistID.uuidString,
            authorID: userID,
            title: "Chill Vibes",
            createdAt: Timestamp(date: Date()),
            filters: [],
            musicISRCs: ["ISRC001", "ISRC002"],
            likes: []
        )
        try await mockService.createPlaylist(playlist: playlistDTO)
        
        // When
        let fetchedPlaylist = try await repository.fetchPlaylist(userID: userID, for: playlistID)
        
        // Then
        XCTAssertNotNil(fetchedPlaylist)
        XCTAssertEqual(fetchedPlaylist?.id, playlistID)
        XCTAssertEqual(fetchedPlaylist?.name, "Chill Vibes")
        XCTAssertEqual(fetchedPlaylist?.musicISRCs, ["ISRC001", "ISRC002"])
    }
    
    /// 로그인이 된 상태에서 플레이리스트 업데이트
    func testAuthenticatedUpdatePlaylist() async throws {
        // Given
        let userID = "user123"
        let playlistID = UUID()
        let originalPlaylistDTO = MolioPlaylistDTO(
            id: playlistID.uuidString,
            authorID: userID,
            title: "Workout Mix",
            createdAt: Timestamp(date: Date()),
            filters: [],
            musicISRCs: ["ISRC003"],
            likes: []
        )
        try await mockService.createPlaylist(playlist: originalPlaylistDTO)
        
        // When
        var updatedPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Workout Mix Updated",
            createdAt: originalPlaylistDTO.createdAt.dateValue(),
            musicISRCs: ["ISRC003", "ISRC004"],
            filter: MusicFilter(genres: [])
        )
        try await repository.updatePlaylist(userID: userID, newPlaylist: updatedPlaylist)
        
        // Then
        let fetchedPlaylistDTO = try await mockService.readPlaylist(playlistID: playlistID)
        XCTAssertEqual(fetchedPlaylistDTO.title, "Workout Mix Updated")
        XCTAssertEqual(fetchedPlaylistDTO.musicISRCs, ["ISRC003", "ISRC004"])
    }
    
    func testAuthenticatedDeletePlaylist() async throws {
        // Given
        let userID = "user123"
        let playlistID = UUID()
        let playlistDTO = MolioPlaylistDTO(
            id: playlistID.uuidString,
            authorID: userID,
            title: "Party Hits",
            createdAt: Timestamp(date: Date()),
            filters: [],
            musicISRCs: ["ISRC005"],
            likes: []
        )
        try await mockService.createPlaylist(playlist: playlistDTO)
        
        // When
        try await repository.deletePlaylist(userID: userID, playlistID)
        
        // Then
        do {
            _ = try await mockService.readPlaylist(playlistID: playlistID)
            XCTFail("삭제했는데 읽어짐")
        } catch {
            XCTAssertEqual(error as? MockFirestoreError, MockFirestoreError.playlistNotFound)
        }
    }
    
    // MARK: - 로그아웃인 상태 테스트

    /// 로그아웃된 플레이리스트 만들기
    func testUnauthenticatedCreatePlaylist() async throws {
        // Given
        let userID: String? = nil
        let playlistID = UUID()
        let playlistName = "Local Playlist"
        
        // When
        try await repository.createNewPlaylist(userID: userID, playlistID: playlistID, playlistName)
        
        // Then
        let fetchedPlaylist = try await mockStorage.read(by: playlistID.uuidString)
        XCTAssertNotNil(fetchedPlaylist)
        XCTAssertEqual(fetchedPlaylist?.id, playlistID)
        XCTAssertEqual(fetchedPlaylist?.name, playlistName)
        XCTAssertTrue(fetchedPlaylist?.musicISRCs.isEmpty ?? false)
    }
    
    /// 로그아웃 된 상태에서 플레이리스트 읽는 테스트

    func testUnauthenticatedReadPlaylist() async throws {
        // Given
        let userID: String? = nil
        let playlistID = UUID()
        let playlist = MolioPlaylist(
            id: playlistID,
            name: "Evening Relax",
            createdAt: Date(),
            musicISRCs: ["ISRC006", "ISRC007"],
            filter: MusicFilter(genres: [])
        )
        try await mockStorage.create(playlist)
        
        // When
        let fetchedPlaylist = try await repository.fetchPlaylist(userID: userID, for: playlistID)
        
        // Then
        XCTAssertNotNil(fetchedPlaylist)
        XCTAssertEqual(fetchedPlaylist?.id, playlistID)
        XCTAssertEqual(fetchedPlaylist?.name, "Evening Relax")
        XCTAssertEqual(fetchedPlaylist?.musicISRCs, ["ISRC006", "ISRC007"])
    }
    
    /// 로그아웃 된 상태에서 플레이리스트 업데이트 하는 테스트
    func testUnauthenticatedUpdatePlaylist() async throws {
        // Given
        let userID: String? = nil
        let playlistID = UUID()
        let originalPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Morning Boost",
            createdAt: Date(),
            musicISRCs: ["ISRC008"],
            filter: MusicFilter(genres: [])
        )
        try await mockStorage.create(originalPlaylist)
        
        // When
        var updatedPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Morning Boost Updated",
            createdAt: originalPlaylist.createdAt,
            musicISRCs: ["ISRC008", "ISRC009"],
            filter: MusicFilter(genres: [])
        )
        try await repository.updatePlaylist(userID: userID, newPlaylist: updatedPlaylist)
        
        // Then
        let fetchedPlaylist = try await mockStorage.read(by: playlistID.uuidString)
        XCTAssertNotNil(fetchedPlaylist)
        XCTAssertEqual(fetchedPlaylist?.name, "Morning Boost Updated")
        XCTAssertEqual(fetchedPlaylist?.musicISRCs, ["ISRC008", "ISRC009"])
    }
    
    /// 로그아웃 된 상태에서 플레이리스트 삭제하는 테스트
    func testUnauthenticatedDeletePlaylist() async throws {
        // Given
        let userID: String? = nil
        let playlistID = UUID()
        let playlist = MolioPlaylist(
            id: playlistID,
            name: "Silent Playlist",
            createdAt: Date(),
            musicISRCs: ["ISRC010"],
            filter: MusicFilter(genres: [])
        )
        try await mockStorage.create(playlist)
        
        // When
        try await repository.deletePlaylist(userID: userID, playlistID)
        
        // Then
        let fetchedPlaylist = try await mockStorage.read(by: playlistID.uuidString)
        XCTAssertNil(fetchedPlaylist)
    }
}
