import Foundation
struct DefaultFollowRelationUseCase: FollowRelationUseCase {
    private let service: FollowRelationService
    private let authService: AuthService
    private let userUseCase: UserUseCase
    
    init(
        service: FollowRelationService = DIContainer.shared.resolve(),
        authService: AuthService = DIContainer.shared.resolve(),
        userUseCase: UserUseCase = DIContainer.shared.resolve()
    ) {
        self.service = service
        self.authService = authService
        self.userUseCase = userUseCase
    }
    
    func requestFollowing(from userID: String, to targetID: String) async throws {
        try await service.createFollowRelation(from: userID, to: targetID)
    }
    
    func approveFollowing(relationID: String) async throws {
        try await service.updateFollowRelation(relationID: relationID, state: true)
    }
    
    func refuseFollowing(relationID: String) async throws {
        try await service.deleteFollowRelation(relationID: relationID)
    }
    
    func unFollow(relationID: String) async throws {
        try await service.deleteFollowRelation(relationID: relationID)
    }
    
    func fetchMyFollowingList() async throws -> [MolioUser] {
        let currentUserID = try await fetchMyUserID()
        let followingRelations = try await service.readFollowRelation(followingID: currentUserID, followerID: nil, state: true)
        
        return try await fetchUsers(from: followingRelations.map { $0.follower })
    }
    
    func fetchFriendFollowingList(friendID: String) async throws -> [MolioUser] {
        let followerRelations = try await service.readFollowRelation(followingID: friendID, followerID: nil, state: true)
        
        return try await fetchUsers(from: followerRelations.map { $0.follower })
    }
    
    func fetchMyFollowerList() async throws -> [MolioFollower] {
        let userID = try await fetchMyUserID()
        let followingRelations = try await service.readFollowRelation(followingID: nil, followerID: userID, state: nil)
        
        return try await fetchFollowers(
            userIDs: followingRelations.map { $0.following },
            states: followingRelations.map { $0.state }
        )
    }
    
    func fetchFriendFollowerList(friendID: String) async throws -> [MolioFollower] {
        let relations = try await service.readFollowRelation(followingID: nil, followerID: friendID, state: true)
        
        return try await fetchFollowers(
            userIDs: relations.map { $0.following },
            states: relations.map { $0.state }
        )
    }
    
    // MARK: - Private Method
    private func fetchMyUserID() async throws -> String {
        return try authService.getCurrentID()
    }
    
    private func fetchUsers(from userIDs: [String]) async throws -> [MolioUser] {
          var users: [MolioUser] = []
          for userID in userIDs {
              if let user = try? await userUseCase.fetchUser(userID: userID) {
                  users.append(user)
              }
          }
          return users
      }
    
    private func fetchFollowers(userIDs: [String], states: [Bool]) async throws -> [MolioFollower] {
        guard userIDs.count == states.count else {
            throw NSError(domain: "InputError", code: 1, userInfo: [NSLocalizedDescriptionKey: "User IDs and states count mismatch"])
        }
        
        var followers: [MolioFollower] = []
        
        try await withThrowingTaskGroup(of: MolioFollower?.self) { group in
            for (userID, state) in zip(userIDs, states) {
                group.addTask {
                    return try? await userUseCase.fetchFollower(userID: userID, state: state)
                }
            }
            
            // 그룹의 결과를 수집
            for try await follower in group {
                if let follower = follower {
                    followers.append(follower)
                }
            }
        }
        
        return followers
    }
}
