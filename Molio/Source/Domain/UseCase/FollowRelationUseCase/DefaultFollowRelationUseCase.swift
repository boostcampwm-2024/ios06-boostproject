struct DefaultFollowRelationUseCase: FollowRelationUseCase {
    private let service: FollowRelationService
    private let authService: AuthService
    
    init(
        service: FollowRelationService,
        authService: AuthService
    ) {
        self.service = service
        self.authService = authService
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
    
    func fetchMyFollowingList() async throws -> [MolioFollowRelation] {
        let userID = try await fetchMyUserID()
        let relations = try await service.readFollowRelation(followingID: userID, followerID: nil, state: true)
        return relations.map { relation in
            MolioFollowRelation(
                id: relation.id,
                date: relation.date,
                following: relation.following,
                follower: relation.follower,
                state: relation.state
            )
        }
    }
    
    func fetchFreindFollowingList(userID: String) async throws -> [MolioFollowRelation] {
        let relations = try await service.readFollowRelation(followingID: userID, followerID: nil, state: true)
        return relations.map { relation in
            MolioFollowRelation(
                id: relation.id,
                date: relation.date,
                following: relation.following,
                follower: relation.follower,
                state: relation.state
            )
        }
    }
    
    func fetchMyFollowerList() async throws -> [MolioFollowRelation] {
        let userID = try await fetchMyUserID()
        let relations = try await service.readFollowRelation(followingID: nil, followerID: userID, state: nil)
        return relations.map { relation in
            MolioFollowRelation(
                id: relation.id,
                date: relation.date,
                following: relation.following,
                follower: relation.follower,
                state: relation.state
            )
        }
    }
    
    func fetchFriendFollowerList(userID: String) async throws -> [MolioFollowRelation] {
        let relations = try await service.readFollowRelation(followingID: nil, followerID: userID, state: true)
        return relations.map { relation in
            MolioFollowRelation(
                id: relation.id,
                date: relation.date,
                following: relation.following,
                follower: relation.follower,
                state: relation.state
            )
        }
    }
    
    // MARK: - Private Method
    private func fetchMyUserID() async throws -> String {
        return try authService.getCurrentID()
    }
}
