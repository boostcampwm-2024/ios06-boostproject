//import XCTest
//@testable import Molio
//
//final class DefaultManageMyPlaylistUseCaseTests: XCTestCase {
//    
//    var useCase: DefaultManageMyPlaylistUseCase!
//    var mockCurrentUserIdUseCase: MockCurrentUserIdUseCase!
//    var mockRepository: MockRealPlaylistRepository!
//
//    override func setUp() {
//        super.setUp()
//        // Mock 객체 초기화
//        mockCurrentUserIdUseCase = MockCurrentUserIdUseCase()
//        mockRepository = MockRealPlaylistRepository()
//
//        // UseCase 초기화
//        useCase = DefaultManageMyPlaylistUseCase(
//            currentUserIdUseCase: mockCurrentUserIdUseCase,
//            playlistRepository: mockRepository
//        )
//    }
//
//    override func tearDown() {
//        useCase = nil
//        mockCurrentUserIdUseCase = nil
//        mockRepository = nil
//        super.tearDown()
//    }
//
//    // MARK: - 테스트 메서드
//
//    /// 플레이리스트 생성 테스트
//    func testCreatePlaylist() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        
//        // When
//        try await useCase.createPlaylist(playlistName: "Test Playlist")
//        
//        // Then
//        XCTAssertTrue(mockRepository.createPlaylistCalled)
//        XCTAssertEqual(mockRepository.createdPlaylistName, "Test Playlist")
//        XCTAssertEqual(mockRepository.createdUserID, "testUserID")
//    }
//
//    /// 플레이리스트 이름 변경 테스트
//    func testUpdatePlaylistName() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        mockRepository.mockPlaylist = MolioPlaylist(
//            id: playlistID,
//            name: "Old Name",
//            createdAt: Date(), musicISRCs: [],
//            filter: MusicFilter(genres: [])
//        )
//        
//        // When
//        try await useCase.updatePlaylistName(playlistID: playlistID.uuidString, name: "New Name")
//        
//        // Then
//        XCTAssertTrue(mockRepository.updatePlaylistCalled)
//        XCTAssertEqual(mockRepository.updatedPlaylist?.name, "New Name")
//    }
//    
//    func testUpdatePlaylistFilter() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        mockRepository.mockPlaylist = MolioPlaylist(
//            id: playlistID,
//            name: "Old Name",
//            createdAt: Date(), musicISRCs: [],
//            filter: MusicFilter(genres: [MusicGenre.acoustic])
//        )
//        
//        // When
//        try await useCase.updatePlaylistFilter(playlistID: playlistID.uuidString, filter: MusicFilter(genres: [MusicGenre.altRock]))
//        
//        // Then
//        XCTAssertTrue(mockRepository.updatePlaylistCalled)
//        XCTAssertEqual(mockRepository.updatedPlaylist?.filter.genres, [MusicGenre.altRock])
//    }
//    
//    /// 플레이리스트 삭제 테스트
//    func testDeletePlaylist() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        
//        // When
//        try await useCase.deletePlaylist(playlistID: playlistID)
//        
//        // Then
//        XCTAssertTrue(mockRepository.deletePlaylistCalled)
//        XCTAssertEqual(mockRepository.deletedPlaylistID, playlistID)
//    }
//    
//    /// 음악 추가 테스트
//    func testAddMusicToPlaylist() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        mockRepository.mockPlaylist = MolioPlaylist(
//            id: playlistID,
//            name: "Playlist Name",
//            createdAt: Date(), musicISRCs: [],
//            filter: MusicFilter(genres: [])
//        )
//        
//        // When
//        try await useCase.addMusic(musicISRC: "ISRC001", to: playlistID)
//        
//        // Then
//        XCTAssertTrue(mockRepository.updatePlaylistCalled)
//        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC001"])
//    }
//
//    /// 음악 이동 테스트
//    func testMoveMusicInPlaylist_1번_인덱스에서_0번_인덱스로_이동하는_경우() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        mockRepository.mockPlaylist = MolioPlaylist(
//            id: playlistID,
//            name: "Playlist Name",
//            createdAt: Date(), musicISRCs: ["ISRC001", "ISRC002", "ISRC003"],
//            filter: MusicFilter(genres: [])
//        )
//        
//        // When
//        try await useCase.moveMusic(musicISRC: "ISRC002", in: playlistID, fromIndex: 1, toIndex: 0)
//        
//        // Then
//        XCTAssertTrue(mockRepository.updatePlaylistCalled)
//        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC002", "ISRC001", "ISRC003"])
//    }
//
//    func testMoveMusicInPlaylist_0번_인덱스에서_1번_인덱스로_이동하는_경우() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        mockRepository.mockPlaylist = MolioPlaylist(
//            id: playlistID,
//            name: "Playlist Name",
//            createdAt: Date(), musicISRCs: ["ISRC001", "ISRC002", "ISRC003"],
//            filter: MusicFilter(genres: [])
//        )
//        
//        // When
//        try await useCase.moveMusic(musicISRC: "ISRC002", in: playlistID, fromIndex: 0, toIndex: 1)
//        
//        // Then
//        XCTAssertTrue(mockRepository.updatePlaylistCalled)
//        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC001", "ISRC002", "ISRC003"])
//    }
//    
//    func testDeleteMusic() async throws {
//        // Given
//        mockCurrentUserIdUseCase.currentUserID = "testUserID"
//        let playlistID = UUID()
//        mockRepository.mockPlaylist = MolioPlaylist(
//            id: playlistID,
//            name: "Playlist Name",
//            createdAt: Date(), musicISRCs: ["ISRC001", "ISRC002", "ISRC003"],
//            filter: MusicFilter(genres: [])
//        )
//        
//        // When
//        try await useCase.deleteMusic(musicISRC: "ISRC001", from: playlistID)
//        
//        // Then
//        XCTAssertEqual(mockRepository.updatedPlaylist?.musicISRCs, ["ISRC002", "ISRC003"])
//    }
//}


import XCTest
@testable import Molio

final class ManageMyPlaylistUseCaseTests: XCTestCase {
    private var sut: ManageMyPlaylistUseCase!
    private var mockCurrentUserIdUseCase: MockCurrentUserIdUseCase!
    private var mockPlaylistRepository: MockRealPlaylistRepository!
    private var mockCurrentPlaylistRepository: MockCurrentPlaylistRepository!
    
    override func setUpWithError() throws {
        mockCurrentUserIdUseCase = MockCurrentUserIdUseCase()
        mockPlaylistRepository = MockRealPlaylistRepository()
        mockCurrentPlaylistRepository = MockCurrentPlaylistRepository()
        sut = DefaultManageMyPlaylistUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            playlistRepository: mockPlaylistRepository,
            currentPlaylistRepository: mockCurrentPlaylistRepository
        )
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockCurrentUserIdUseCase = nil
        mockPlaylistRepository = nil
        mockCurrentPlaylistRepository = nil
    }
    
    // MARK: - CurrentUserID가 없어도 PlaylistRepository의 메서드는 호출되어야 한다.
    
    func test_addMusic_호출시_현재유저ID가_없어도_playlistRepository의_updatePlaylistCalled은_호출된다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        mockPlaylistRepository.mockPlaylist = MolioPlaylist.mock
        // When
        try await sut.addMusic(musicISRC: "", to: UUID())
        // Then
        XCTAssertTrue(mockPlaylistRepository.updatePlaylistCalled)
    }
    
    func test_deleteMusic_호출시_현재유저ID가_없어도_playlistRepository의_updatePlaylistCalled은_호출된다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        mockPlaylistRepository.mockPlaylist = MolioPlaylist.mock
        // When
        try await sut.deleteMusic(musicISRC: "", from: UUID())
        // Then
        XCTAssertTrue(mockPlaylistRepository.updatePlaylistCalled)
    }
    
    func test_createPlaylist_호출시_현재유저ID가_없어도_playlistRepository의_createNewPlaylist는_호출된다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        // When
        try await sut.createPlaylist(playlistName: "")
        // Then
        XCTAssertTrue(mockPlaylistRepository.createNewPlaylistCalled)
    }
    
    func test_deletePlaylist_호출시_현재유저ID가_없어도_playlistRepository의_deletePlaylist는_호출된다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        mockPlaylistRepository.mockPlaylist = MolioPlaylist.mock
        // When
        try await sut.deletePlaylist(playlistID: UUID())
        // Then
        XCTAssertTrue(mockPlaylistRepository.deletePlaylistCalled)
    }
    
    func test_updatePlaylistName_호출시_현재유저ID가_없어도_playlistRepository의_updatePlaylistCalled는_호출된다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        mockPlaylistRepository.mockPlaylist = MolioPlaylist.mock
        // When
        try await sut.updatePlaylistName(playlistID: UUID(), name: "")
        // Then
        XCTAssertTrue(mockPlaylistRepository.updatePlaylistCalled)
    }
    
    func test_updatePlaylistFilter_호출시_현재유저ID가_없어도_playlistRepository의_updatePlaylistCalled는_호출된다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        mockPlaylistRepository.mockPlaylist = MolioPlaylist.mock
        // When
        try await sut.updatePlaylistFilter(playlistID: UUID(), filter: MusicFilter(genres: []))
        // Then
        XCTAssertTrue(mockPlaylistRepository.updatePlaylistCalled)
    }
    
    // MARK: - 로직 확인
    
    func test_moveMusic_호출시_이동할_인덱스가_같으면_playlistRepository의_updatePlaylist는_호출되지_않는다() async throws {
        // Given
        mockCurrentUserIdUseCase.userIDToReturn = nil
        // When
        try await sut.moveMusic(musicISRC: "", in: UUID(), fromIndex: 0, toIndex: 0)
        // Then
        XCTAssertFalse(mockPlaylistRepository.updatePlaylistCalled)
    }
}
