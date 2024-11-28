import XCTest
@testable import Molio

final class DefaultCommunityUseCaseTests: XCTestCase {
    var useCase: DefaultCommunityUseCase!
    var mockRepository: MockPlaylistRepository!
    var mockCurrentUserIdUseCase: MockCurrentUserIdUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPlaylistRepository()
        mockCurrentUserIdUseCase = MockCurrentUserIdUseCase()
        useCase = DefaultCommunityUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            repository: mockRepository
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
        mockCurrentUserIdUseCase = nil
        super.tearDown()
    }
    
    func testLikePlaylist() async throws {
        // Given
        let userID = "testUser"
        let playlistID = UUID()
        let initialLikes: [String] = []
        let playlist = MolioPlaylist(
            id: playlistID,
            authorID: userID,
            name: "Test Playlist",
            createdAt: Date(),
            musicISRCs: [],
            filter: MusicFilter(genres: []),
            like: initialLikes
        )
        
        mockCurrentUserIdUseCase.currentUserID = userID
        mockRepository.stubbedPlaylist = playlist
        
        // When
        try await useCase.likePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockRepository.didUpdatePlaylist)
        XCTAssertEqual(mockRepository.updatedPlaylist?.like?.contains(userID), true)
    }
    
    func testUnlikePlaylist() async throws {
        // Given
        let userID = "testUser"
        let playlistID = UUID()
        let initialLikes: [String] = [userID]
        let playlist = MolioPlaylist(
            id: playlistID,
            authorID: userID,
            name: "Test Playlist",
            createdAt: Date(),
            musicISRCs: [],
            filter: MusicFilter(genres: []),
            like: initialLikes
        )
        
        mockCurrentUserIdUseCase.currentUserID = userID
        mockRepository.stubbedPlaylist = playlist
        
        // When
        try await useCase.unlikePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockRepository.didUpdatePlaylist)
        XCTAssertEqual(mockRepository.updatedPlaylist?.like?.contains(userID), false)
    }
}

final class MockPlaylistRepository: RealPlaylistRepository {
    var stubbedPlaylist: MolioPlaylist?
    var didUpdatePlaylist = false
    var updatedPlaylist: MolioPlaylist?
    
    func addMusic(userID: String?, isrc: String, to playlistID: UUID) async throws {}
    func deleteMusic(userID: String?, isrc: String, in playlistID: UUID) async throws {}
    func moveMusic(userID: String?, isrc: String, in playlistID: UUID, fromIndex: Int, toIndex: Int) async throws {}
    func createNewPlaylist(userID: String?, playlistID: UUID, _ playlistName: String) async throws {}
    func deletePlaylist(userID: String?, _ playlistID: UUID) async throws {}
    
    func fetchPlaylists(userID: String?) async throws -> [MolioPlaylist]? {
        return [stubbedPlaylist].compactMap { $0 }
    }
    
    func fetchPlaylist(userID: String?, for playlistID: UUID) async throws -> MolioPlaylist? {
        return stubbedPlaylist
    }
    
    func updatePlaylist(userID: String?, newPlaylist: MolioPlaylist) async throws {
        didUpdatePlaylist = true
        updatedPlaylist = newPlaylist
    }
}
