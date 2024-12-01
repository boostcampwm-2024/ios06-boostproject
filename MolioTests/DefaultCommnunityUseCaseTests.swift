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
        
        mockCurrentUserIdUseCase.userIDToReturn = userID
        mockRepository.mockPlaylist = playlist
        useCase = DefaultCommunityUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            repository: mockRepository
        )
        
        // When
        try await useCase.likePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.like.contains(userID), true)
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
        mockRepository.mockPlaylist = playlist
        useCase = DefaultCommunityUseCase(
            currentUserIdUseCase: mockCurrentUserIdUseCase,
            repository: mockRepository
        )
        
        // When
        try await useCase.unlikePlaylist(playlistID: playlistID)
        
        // Then
        XCTAssertTrue(mockRepository.updatePlaylistCalled)
        XCTAssertEqual(mockRepository.updatedPlaylist?.like.contains(userID), false)
    }
}
