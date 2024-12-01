import XCTest
@testable import Molio

final class DefaultCommunityUseCaseTests: XCTestCase {
    var useCase: DefaultCommunityUseCase!
    var mockPlaylistRepository: MockPlaylistRepository!
    var mockCurrentUserIdUseCase: MockCurrentUserIdUseCase!
    
    override func setUp() {
        super.setUp()
        mockPlaylistRepository = MockPlaylistRepository()
        mockCurrentUserIdUseCase = MockCurrentUserIdUseCase()
        useCase = DefaultCommunityUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            playlistRepository: mockPlaylistRepository
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockPlaylistRepository = nil
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
        
        mockCurrentUserIdUseCase.userIDToReturn = userID
        mockPlaylistRepository.mockPlaylist = playlist
        useCase = DefaultCommunityUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            playlistRepository: mockPlaylistRepository
        )
        
        // When
        try await useCase.likePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockPlaylistRepository.updatePlaylistCalled)
        XCTAssertEqual(mockPlaylistRepository.updatedPlaylist?.like.contains(userID), true)
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
        
        mockCurrentUserIdUseCase.userIDToReturn = userID
        mockPlaylistRepository.mockPlaylist = playlist
        useCase = DefaultCommunityUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            playlistRepository: mockPlaylistRepository
        )
        
        // When
        try await useCase.unlikePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockPlaylistRepository.updatePlaylistCalled)
        XCTAssertEqual(mockPlaylistRepository.updatedPlaylist?.like.contains(userID), false)
    }
}
