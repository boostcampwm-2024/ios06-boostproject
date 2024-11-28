import Foundation
@testable import Molio

final class MockFollowRelationService: FollowRelationService {
    var createdRelations: [FollowRelationDTO] = []
    var updatedRelations: [String: Bool] = [:]
    var deletedRelations: [String] = []
    var fetchedRelations: [FollowRelationDTO] = []
    
    func createFollowRelation(from followerID: String, to followingID: String) async throws {
        let relation = FollowRelationDTO(
            id: UUID().uuidString,
            date: Date(),
            following: followingID,
            follower: followerID,
            state: false
        )
        createdRelations.append(relation)
    }
    
    func readFollowRelation(followingID: String?, followerID: String?, state: Bool?) async throws -> [FollowRelationDTO] {
        return fetchedRelations.filter { relation in
            (followingID == nil || relation.following == followingID) &&
            (followerID == nil || relation.follower == followerID) &&
            (state == nil || relation.state == state)
        }
    }
    
    func updateFollowRelation(relationID: String, state: Bool) async throws {
        updatedRelations[relationID] = state
    }
    
    func deleteFollowRelation(relationID: String) async throws {
        deletedRelations.append(relationID)
    }
}
