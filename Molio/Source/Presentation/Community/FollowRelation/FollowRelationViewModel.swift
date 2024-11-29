import Combine
import SwiftUI

final class FollowRelationViewModel: ObservableObject {
    @Published var followerUsers: [MolioFollower] = []
    @Published var followingUsers: [MolioUser] = []

    private let followRelationUseCase: FollowRelationUseCase
    private let userUseCase: UserUseCase
    
    init(
        followRelationUseCase: FollowRelationUseCase, 
        userUseCase: UserUseCase
    ) {
        self.followRelationUseCase = followRelationUseCase
        self.userUseCase = userUseCase
    }
    
    func fecthMydData(followRelationType: FollowRelationType) async throws{
        switch followRelationType {
            case .unfollowing: // 팔로워
                let users = try await followRelationUseCase.fetchMyFollowerList()
                DispatchQueue.main.async {
                    self.followerUsers = users
                }
            case .following:  // 팔로잉
                let users = try await followRelationUseCase.fetchMyFollowingList()
                DispatchQueue.main.async {
                    self.followingUsers = users
                }
            }
    }
    
    func fecthFreindData(followRelationType: FollowRelationType, friendUserID: String) async throws{
        switch followRelationType {
            case .unfollowing: // 팔로워
                let users = try await followRelationUseCase.fetchFriendFollowerList(userID: friendUserID)
                DispatchQueue.main.async {
                    self.followerUsers = users
                }
            case .following:  // 팔로잉
            let users = try await followRelationUseCase.fetchFreindFollowingList(userID: friendUserID)
                DispatchQueue.main.async {
                    self.followingUsers = users
                }
            }
    }
}
