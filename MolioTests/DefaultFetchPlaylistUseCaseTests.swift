import XCTest
@testable import Molio

final class DefaultFetchPlaylistUseCaseTests: XCTestCase {
    
    var playlistRepository: RealPlaylistRepository!
    var musicKitService: MusicKitService!
    var currentUserIdUseCase: MockCurrentUserIdUseCase2!
    var fetchPlaylistUseCase: DefaultFetchPlaylistUseCase!
    var playlistService: FirestorePlaylistService!
    
    var createdPlaylistIDs: [UUID] = []

    override func setUp() {
        super.setUp()
        playlistRepository = DefaultPlaylistRepository(playlistStorage: MockPlaylistLocalStorage())
        
        musicKitService = DefaultMusicKitService()
        currentUserIdUseCase = MockCurrentUserIdUseCase2()
        
        fetchPlaylistUseCase = DefaultFetchPlaylistUseCase(
            playlistRepisitory: playlistRepository,
            musicKitService: musicKitService,
            currentUserIDUseCase: currentUserIdUseCase
        )
        
        playlistService = FirestorePlaylistService()
    }
    
    override func tearDown() async throws {
        playlistRepository = nil
        musicKitService = nil
        currentUserIdUseCase = nil
        fetchPlaylistUseCase = nil
        
        for playlistID in createdPlaylistIDs {
            try? await playlistService.deletePlaylist(playlistID: playlistID)
        }
        
        try? await super.tearDown()
    }
    
    // MARK: - Test Methods
    
    func testFetchMyAllPlaylists() async throws {
        let currentUserId = try currentUserIdUseCase.execute()

        // Given
        // 필요한 사전 조건 설정 (예: Mock 데이터 설정)
        let playlist = MolioPlaylist(
            id: UUID(),
            authorID: currentUserId,
            name: "창우의 플레이리스트",
            createdAt: .now,
            musicISRCs: ["USUM72012345"],
            filter: MusicFilter(
                genres: [.acoustic]
            ),
            like: []
        )
        
        let service = FirestorePlaylistService()
        
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: playlist))
        
        // When
        let playlists = try await fetchPlaylistUseCase.fetchMyAllPlaylists()
        
        // Then
        // 결과 검증
        XCTAssertTrue(playlists.contains(where: {$0.authorID == currentUserId}), "플레이리스트 목록에 해당 플레이리스트가 포함되어 있어야 합니다.")
    }
    
    func testFetchMyPlaylist() async throws {
        let currentUserId = try currentUserIdUseCase.execute()
        let playlistID = UUID()
        
        // Given
        let playlist = MolioPlaylist(
            id: playlistID,
            authorID: currentUserId,
            name: "창우의 특정 플레이리스트",
            createdAt: .now,
            musicISRCs: ["USUM72012345"],
            filter: MusicFilter(
                genres: [.acoustic]
            ),
            like: []
        )
        
        let service = FirestorePlaylistService()
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: playlist))
        createdPlaylistIDs.append(playlistID)
        // When
        let fetchedPlaylist = try await fetchPlaylistUseCase.fetchMyPlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertNotNil(fetchedPlaylist, "플레이리스트는 nil이 아니어야 합니다.")
        XCTAssertEqual(fetchedPlaylist.id, playlistID, "플레이리스트 ID가 일치해야 합니다.")
    }
    
    
    func testFetchAllMusicInPlaylist() async throws {
        let mockID = UUID()
        
        let mockPlaylist = MolioPlaylist.mock.copy(id: mockID, authorID: "창우", musicISRCs: ["QZK6M2033033"])
        
        let service = FirestorePlaylistService()
        
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: mockPlaylist))
        
        createdPlaylistIDs.append(mockID)

        // Given
        
        // When
        let fetchedMusics = try await fetchPlaylistUseCase.fetchAllMyMusicIn(playlistID: mockID)
        
        // Then
        XCTAssertEqual(mockPlaylist.musicISRCs, fetchedMusics.map { $0.isrc })
        // 추가적인 XCTAssert를 통해 리스트의 내용 검증
    }
    
    func testFetchFriendAllPlaylists() async throws {
        // Given
        let friendUserID = "창창우" // 테스트용 친구 사용자 ID 설정
        // Mock 또는 실제 데이터 설정
        
        // 두 개의 플레이리스트 생성
        let playlist1 = MolioPlaylist(
            id: UUID(),
            authorID: friendUserID,
            name: "창창우의 첫 번째 플레이리스트",
            createdAt: .now,
            musicISRCs: ["USUM72012345"],
            filter: MusicFilter(
                genres: [.rock]
            ),
            like: []
        )
        
        let playlist2 = MolioPlaylist(
            id: UUID(),
            authorID: friendUserID,
            name: "창창우의 두 번째 플레이리스트",
            createdAt: .now,
            musicISRCs: ["QZK6M2033033", "USUM72067890"],
            filter: MusicFilter(
                genres: [.pop]
            ),
            like: []
        )
        
        let service = FirestorePlaylistService()
        
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: playlist1))
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: playlist2))

        createdPlaylistIDs.append(playlist1.id)
        createdPlaylistIDs.append(playlist2.id)

        // When
        let playlists = try await fetchPlaylistUseCase.fetchFriendAllPlaylists(friendUserID: friendUserID)
        
        // Then
        print(playlists)
        XCTAssertNotNil(playlists, "친구의 플레이리스트는 nil이 아니어야 합니다.")
    }
    
    func testFetchFriendPlaylist() async throws {
        // Given
        let friendUserID = "friendUser123"
        let playlistID = UUID()
        let playlist = MolioPlaylist(
            id: playlistID,
            authorID: friendUserID,
            name: "친구의 특정 플레이리스트",
            createdAt: .now,
            musicISRCs: ["QZK6M2033033"],
            filter: MusicFilter(
                genres: [.jazz]
            ),
            like: []
        )
        
        let service = FirestorePlaylistService()
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: playlist))
        
        createdPlaylistIDs.append(playlist.id)

        // When
        let fetchedPlaylist = try await fetchPlaylistUseCase.fetchFriendPlaylist(friendUserID: friendUserID, playlistID: playlistID)
        
        // Then
        XCTAssertNotNil(fetchedPlaylist, "친구의 특정 플레이리스트는 nil이 아니어야 합니다.")
        XCTAssertEqual(fetchedPlaylist.id, playlistID, "플레이리스트 ID가 일치해야 합니다.")
    }

    
    func testFetchAllFriendMusics() async throws {
        // Given
        let friendUserID = "friendUser123"
        let playlistID = UUID()
        let playlist = MolioPlaylist(
            id: playlistID,
            authorID: friendUserID,
            name: "친구의 음악 목록",
            createdAt: .now,
            musicISRCs: ["QZK6M2033033", "QZK6M2033030"],
            filter: MusicFilter(
                genres: [.pop]
            ),
            like: []
        )
        
        let service = FirestorePlaylistService()
        try await service.createPlaylist(playlist: MolioPlaylistMapper.map(from: playlist))
        
        createdPlaylistIDs.append(playlist.id)

        // When
        let musics = try await fetchPlaylistUseCase.fetchAllFriendMusics(friendUserID: friendUserID, playlistID: playlistID)
        
        // Then
        XCTAssertNotNil(musics, "친구의 음악 목록은 nil이 아니어야 합니다.")
        
        // TODO: 노래 순서는 보장되지 않음 (TaskGroup 때문에)
//        XCTAssertEqual(playlist.musicISRCs, musics.map { $0.isrc }, "음악 ISRC 목록이 일치해야 합니다.")
    }
}

// MARK: - Mock Classes

class MockCurrentUserIdUseCase2: CurrentUserIdUseCase {
    func execute() throws -> String? {
        return "창우"
    }
}

