import XCTest
@testable import Molio

final class DefaultCommunityUseCaseTests: XCTestCase {
    var useCase: DefaultCommunityUseCase!
    var mockService: MockFollowRelationService!
    var mockAuthService: MockAuthService!
    
    override func setUp() {
        super.setUp()
        mockService = MockFollowRelationService()
        mockAuthService = MockAuthService()
        
        useCase = DefaultCommunityUseCase(service: mockService, authService: mockAuthService)
    }
    
    override func tearDown() {
        mockService = nil
        useCase = nil
        super.tearDown()
    }
    
    func testFollowing() async throws {
        let followerID = "user1"
        let followingID = "user2"
        
        try await useCase.following(from: followerID, to: followingID)
        
        XCTAssertEqual(mockService.createdRelations.count, 1)
        XCTAssertEqual(mockService.createdRelations.first?.follower, followerID)
        XCTAssertEqual(mockService.createdRelations.first?.following, followingID)
        XCTAssertFalse(mockService.createdRelations.first?.state ?? true)
    }
    
    func testApproveFollowing() async throws {
        let relationID = "relation1"
        
        try await useCase.approveFollowing(relationID: relationID)
        
        XCTAssertEqual(mockService.updatedRelations[relationID], true)
    }
    
    func testRefuseFollowing() async throws {
        let relationID = "relation2"
        
        try await useCase.refuseFollowing(relationID: relationID)
        
        XCTAssertTrue(mockService.deletedRelations.contains(relationID))
    }
    
    func testUnFollow() async throws {
        let relationID = "relation3"
        
        try await useCase.unFollow(relationID: relationID)
        
        XCTAssertTrue(mockService.deletedRelations.contains(relationID))
    }
    
    func testFetchMyFollowingList() async throws {
        let userID = "myUserID"
        mockService.fetchedRelations = [
            FollowRelationDTO(id: userID, date: Date(), following: userID, follower: "user2", state: true),
            FollowRelationDTO(id: userID, date: Date(), following: userID, follower: "user3", state: true)
        ]
        
        let results = try await useCase.fetchMyFollowingList()
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.following == userID })
    }
    func testFetchFriendFollowingList() async throws {
        let userID = "user1"
        mockService.fetchedRelations = [
            FollowRelationDTO(id: "relation1", date: Date(), following: userID, follower: "user2", state: true),
            FollowRelationDTO(id: "relation2", date: Date(), following: userID, follower: "user3", state: true)
        ]
        
        let results = try await useCase.fetchFreindFollowingList(userID: userID )
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.following == userID })
    }
    func testFetchMyFollowerList() async throws {
        let userID = "myUserID"
        mockService.fetchedRelations = [
            FollowRelationDTO(id: userID, date: Date(), following: "user2", follower: userID, state: false),
            FollowRelationDTO(id: userID, date: Date(), following: "user3", follower: userID, state: false)
        ]
        
        let results = try await useCase.fetchMyFollowerList()
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.follower == userID })
    }
    
    func testFetchFriendFollowerList() async throws {
        let userID = "user1"
        mockService.fetchedRelations = [
            FollowRelationDTO(id: "relation1", date: Date(), following: "user2", follower: userID, state: true),
            FollowRelationDTO(id: "relation2", date: Date(), following: "user3", follower: userID, state: true)
        ]
        
        let results = try await useCase.fetchFriendFollowerList(userID: userID)
        
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.follower == userID && $0.state == true })
    }
}
