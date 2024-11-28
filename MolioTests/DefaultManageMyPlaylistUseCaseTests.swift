import XCTest
@testable import Molio

final class DefaultManageMyPlaylistUseCaseTests: XCTestCase {
    
    var useCase: DefaultManageMyPlaylistUseCase!
    var mockCurrentUserIdUseCase: MockCurrentUserIdUseCase!
    var mockRepository: MockRealPlaylistRepository!

    override func setUp() {
        super.setUp()
        // Mock 객체 초기화
        mockCurrentUserIdUseCase = MockCurrentUserIdUseCase()
        mockRepository = MockRealPlaylistRepository()

        // UseCase 초기화
        useCase = DefaultManageMyPlaylistUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            repository: mockRepository
        )
    }

    override func tearDown() {
        useCase = nil
        mockCurrentUserIdUseCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - 테스트 메서드

    /// 플레이리스트 생성 테스트
    func testCreatePlaylist() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        
        // When
        try await useCase.createPlaylist(playlistName: "Test Playlist")
        
        // Then
        XCTAssertTrue(mockRepository.createPlaylistCalled)
        XCTAssertEqual(mockRepository.createdPlaylistName, "Test Playlist")
        XCTAssertEqual(mockRepository.createdUserID, "testUserID")
    }

    /// 플레이리스트 이름 변경 테스트
    func testUpdatePlaylistName() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        mockRepository.mockPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Old Name",
            createdAt: Date(), musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        
        // When
        try await useCase.updatePlaylistName(playlistID: playlistID.uuidString, name: "New Name")
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.name, "New Name")
    }
    
    func testUpdatePlaylistFilter() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        mockRepository.mockPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Old Name",
            createdAt: Date(), musicISRCs: [],
            filter: MusicFilter(genres: [MusicGenre.acoustic])
        )
        
        // When
        try await useCase.updatePlaylistFilter(playlistID: playlistID.uuidString, filter: MusicFilter(genres: [MusicGenre.altRock]))
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.filter.genres, [MusicGenre.altRock])
    }
    
    /// 플레이리스트 삭제 테스트
    func testDeletePlaylist() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        
        // When
        try await useCase.deletePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockRepository.deletePlaylistCalled)
        XCTAssertEqual(mockRepository.deletedPlaylistID, playlistID)
    }
    
    /// 음악 추가 테스트
    func testAddMusicToPlaylist() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        mockRepository.mockPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Playlist Name",
            createdAt: Date(), musicISRCs: [],
            filter: MusicFilter(genres: [])
        )
        
        // When
        try await useCase.addMusic(musicISRC: "ISRC001", to: playlistID)
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC001"])
    }

    /// 음악 이동 테스트
    func testMoveMusicInPlaylist_1번_인덱스에서_0번_인덱스로_이동하는_경우() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        mockRepository.mockPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Playlist Name",
            createdAt: Date(), musicISRCs: ["ISRC001", "ISRC002", "ISRC003"],
            filter: MusicFilter(genres: [])
        )
        
        // When
        try await useCase.moveMusic(musicISRC: "ISRC002", in: playlistID, fromIndex: 1, toIndex: 0)
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC002", "ISRC001", "ISRC003"])
    }

    func testMoveMusicInPlaylist_0번_인덱스에서_1번_인덱스로_이동하는_경우() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        mockRepository.mockPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Playlist Name",
            createdAt: Date(), musicISRCs: ["ISRC001", "ISRC002", "ISRC003"],
            filter: MusicFilter(genres: [])
        )
        
        // When
        try await useCase.moveMusic(musicISRC: "ISRC002", in: playlistID, fromIndex: 0, toIndex: 1)
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC001", "ISRC002", "ISRC003"])
    }
    
    func testDeleteMusic() async throws {
        // Given
        mockCurrentUserIdUseCase.currentUserID = "testUserID"
        let playlistID = UUID()
        mockRepository.mockPlaylist = MolioPlaylist(
            id: playlistID,
            name: "Playlist Name",
            createdAt: Date(), musicISRCs: ["ISRC001", "ISRC002", "ISRC003"],
            filter: MusicFilter(genres: [])
        )
        
        // When
        try await useCase.deleteMusic(musicISRC: "ISRC001", from: playlistID)
        
        // Then
        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC002", "ISRC003"])
    }
}

final class MockCurrentUserIdUseCase: CurrentUserIdUseCase {
    var currentUserID: String?
    func execute() throws -> String? {
        return currentUserID
    }
}
