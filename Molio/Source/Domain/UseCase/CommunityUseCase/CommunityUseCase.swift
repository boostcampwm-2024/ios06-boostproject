protocol CommunityUseCase {
    func following(from userID: String, to targetID: String) async throws
    func approveFollowing(relationID: String) async throws
    func refuseFollowing(relationID: String) async throws
    func unFollow(relationID: String) async throws
    
    func fetchFollowList(userID: String) async throws -> [MolioFollowRelation]
    func fetchFollowingList(userID: String) async throws -> [MolioFollowRelation]
}
