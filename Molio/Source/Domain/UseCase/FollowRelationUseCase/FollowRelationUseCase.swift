protocol FollowRelationUseCase {
    func requestFollowing(from userID: String, to targetID: String) async throws
    func approveFollowing(relationID: String) async throws
    func refuseFollowing(relationID: String) async throws
    func unFollow(relationID: String) async throws
    func fetchMyFollowingList() async throws -> [MolioFollowRelation]
    func fetchFreindFollowingList(userID: String) async throws -> [MolioFollowRelation]
    func fetchMyFollowerList() async throws -> [MolioFollowRelation]
    func fetchFriendFollowerList(userID: String) async throws -> [MolioFollowRelation]
}
