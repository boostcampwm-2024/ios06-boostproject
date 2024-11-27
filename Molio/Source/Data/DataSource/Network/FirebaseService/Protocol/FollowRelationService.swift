protocol FollowRelationService {
    func createFollowRelation(from followerID: String, to followingID: String) async throws
    func readFollowRelation(followingID: String?, followerID: String?, state: Bool?) async throws -> [FollowRelationDTO]
    func updateFollowRelation(relationID: String, state: Bool) async throws
    func deleteFollowRelation(relationID: String) async throws
}
