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
    
    func requestFollowing(to targetID: String) async throws {
        let currentUserID = try await fetchMyUserID()
        try await service.createFollowRelation(from: currentUserID, to: targetID)
    }
    
    func approveFollowing(relationID: String) async throws {
        try await service.updateFollowRelation(relationID: relationID, state: true)
    }
    
    func refuseFollowing(relationID: String) async throws {
        try await service.deleteFollowRelation(relationID: relationID)
    }
    
    func fetchFollowRelation(for userID: String) async throws -> FollowRelationType {
        let currentUserID = try await fetchMyUserID()
        let relation = try await service.readFollowRelation(
            followingID: currentUserID,
            followerID: userID,
            state: nil
        )
        return relation.isEmpty ? .unfollowing : .following
    }
    
    func unFollow(to targetID: String) async throws {
        let currentUserID = try await fetchMyUserID()
        guard let relationID = try await service.readFollowRelation(followingID: currentUserID, followerID: targetID, state: true).first?.id else { return }
        try await service.deleteFollowRelation(relationID: relationID)
    }
    
    /// 내가 팔로잉한 사용자 목록
    func fetchMyFollowingList() async throws -> [MolioFollower] {
        let currentUserID = try await fetchMyUserID()
        let followingRelations = try await service.readFollowRelation(
            followingID: currentUserID, // 내가 followingID로 등록된 관계
            followerID: nil,
            state: nil
        )
        
        // 팔로잉 상태 포함하여 MolioFollower 변환
        return try await convertToMolioFollowers(
            from: followingRelations.map { $0.follower },
            currentUserID: currentUserID
        )
    }

    /// 나를 팔로잉한 사용자 목록
    func fetchMyFollowerList() async throws -> [MolioFollower] {
        let currentUserID = try await fetchMyUserID()
        let followerRelations = try await service.readFollowRelation(
            followingID: nil,
            followerID: currentUserID, // 내가 followerID로 등록된 관계
            state: nil
        )
        
        // 팔로우 상태 포함하여 MolioFollower 변환
        return try await convertToMolioFollowers(
            from: followerRelations.map { $0.following },
            currentUserID: currentUserID
        )
    }

    /// 친구가 팔로잉한 사용자 목록
    func fetchFriendFollowingList(friendID: String) async throws -> [MolioFollower] {
        let followingRelations = try await service.readFollowRelation(
            followingID: friendID, // 친구가 followingID로 등록된 관계
            followerID: nil,
            state: nil
        )
        
        // 친구의 팔로잉 상태 포함하여 MolioFollower 변환
        return try await convertToMolioFollowers(
            from: followingRelations.map { $0.follower },
            currentUserID: friendID
        )
    }

    /// 친구를 팔로잉한 사용자 목록
    func fetchFriendFollowerList(friendID: String) async throws -> [MolioFollower] {
        let followerRelations = try await service.readFollowRelation(
            followingID: nil,
            followerID: friendID, // 친구가 followerID로 등록된 관계
            state: nil
        )
        
        // 친구의 팔로워 상태 포함하여 MolioFollower 변환
        return try await convertToMolioFollowers(
            from: followerRelations.map { $0.following },
            currentUserID: friendID
        )
    }
    
    /// 팔로잉 여부를 포함한 모든 사용자의 목록 
    func fetchAllFollowers() async throws -> [MolioFollower] {
        // 모든 유저 데이터를 가져옴
        let users = try await userUseCase.fetchAllUsers()
        
        // 현재 로그인한 사용자 ID
        let currentUserID = try await fetchMyUserID()
        
        // 내가 팔로우한 사용자 목록 가져옴
        let relations = try await service.readFollowRelation(
            followingID: currentUserID, // 내가 followingID로 등록된 관계
            followerID: nil,
            state: nil
        )
        
        // 내가 팔로우한 사용자 ID 목록
        let followingIDs = Set(relations.map { $0.follower })
        
        // 모든 사용자 데이터를 MolioFollower로 변환하며 내가 팔로우했는지 여부를 설정
        return users.map { user in
            MolioFollower(
                id: user.id,
                name: user.name,
                profileImageURL: user.profileImageURL,
                description: user.description,
                followRelation: followingIDs.contains(user.id) ? .following : .unfollowing
            )
        }
    }
    
    /// 팔로잉 여부를 포함한 사용자 불러오기
    func fetchFollower(userID: String) async throws -> MolioFollower {
        let user = try await userUseCase.fetchUser(userID: userID)
        
        // 현재 로그인한 사용자 ID
        let currentUserID = try await fetchMyUserID()
        
        // 내가 팔로우한 사용자 목록 가져옴
        let relations = try await service.readFollowRelation(
            followingID: currentUserID, // 내가 followingID로 등록된 관계
            followerID: nil,
            state: nil
        )
        
        // 내가 팔로우한 사용자 ID 목록
        let followingIDs = Set(relations.map { $0.follower })
        
        // 모든 사용자 데이터를 MolioFollower로 변환하며 내가 팔로우했는지 여부를 설정
        return MolioFollower(
                id: user.id,
                name: user.name,
                profileImageURL: user.profileImageURL,
                description: user.description,
                followRelation: followingIDs.contains(user.id) ? .following : .unfollowing
            )
        
    }

    // MARK: - Private Helpers

    private func fetchMyUserID() async throws -> String {
        return try authService.getCurrentID()
    }

    /// 사용자 ID 목록을 기반으로 사용자 데이터를 가져와 MolioFollower로 변환
    private func convertToMolioFollowers(
        from userIDs: [String],
        currentUserID: String
    ) async throws -> [MolioFollower] {
        // 현재 사용자가 팔로우 중인 사용자 ID를 가져옴
        let followingRelations = try await service.readFollowRelation(
            followingID: currentUserID,
            followerID: nil,
            state: nil
        )
        let followingIDs = Set(followingRelations.map { $0.follower })

        // 사용자 데이터를 가져옴
        let users = try await fetchUsers(from: userIDs)

        // 사용자 데이터를 MolioFollower로 변환하며 팔로우 상태 설정
        return users.map { user in
            let isFollowing = followingIDs.contains(user.id)
            return MolioFollower(
                id: user.id,
                name: user.name,
                profileImageURL: user.profileImageURL,
                description: user.description,
                followRelation: isFollowing ? .following : .unfollowing
            )
        }
    }
    /// 사용자 ID 목록을 기반으로 사용자 데이터를 가져옴
    private func fetchUsers(from userIDs: [String]) async throws -> [MolioUser] {
        return try await withThrowingTaskGroup(of: MolioUser?.self) { group in
            for userID in userIDs {
                group.addTask {
                    return try? await self.userUseCase.fetchUser(userID: userID)
                }
            }

            return try await group.reduce(into: [MolioUser]()) { result, user in
                if let user = user {
                    result.append(user)
                }
            }
        }
    }
}
