protocol FollowRelationUseCase {
    func requestFollowing(from userID: String, to targetID: String) async throws
    func approveFollowing(relationID: String) async throws
    func refuseFollowing(relationID: String) async throws
    func unFollow(relationID: String) async throws
    func fetchAllFollowers() async throws -> [MolioFollower]
    func fetchMyFollowingList() async throws -> [MolioFollower]
    func fetchFriendFollowingList(friendID: String) async throws -> [MolioFollower]
    func fetchMyFollowerList() async throws -> [MolioFollower]
    func fetchFriendFollowerList(friendID: String) async throws -> [MolioFollower]
}
