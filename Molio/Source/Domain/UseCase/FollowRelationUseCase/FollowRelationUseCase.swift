protocol FollowRelationUseCase {
    func requestFollowing(to targetID: String) async throws
    func approveFollowing(relationID: String) async throws
    func refuseFollowing(relationID: String) async throws
    func unFollow(to targetID: String) async throws
    func fetchFollowRelation(for userID: String) async throws -> FollowRelationType
    func fetchAllFollowers() async throws -> [MolioFollower]
    func fetchMyFollowingList() async throws -> [MolioFollower]
    func fetchFriendFollowingList(friendID: String) async throws -> [MolioFollower]
    func fetchMyFollowerList() async throws -> [MolioFollower]
    func fetchFriendFollowerList(friendID: String) async throws -> [MolioFollower]
}
