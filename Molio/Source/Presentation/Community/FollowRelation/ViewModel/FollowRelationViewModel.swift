import Combine
import SwiftUI

final class FollowRelationViewModel: ObservableObject {
    @Published var users: [MolioFollower] = []
    private let followRelationUseCase: FollowRelationUseCase
    private let userUseCase: UserUseCase
    
    init(
        followRelationUseCase: FollowRelationUseCase = DIContainer.shared.resolve(),
        userUseCase: UserUseCase = DIContainer.shared.resolve()
    ) {
        self.followRelationUseCase = followRelationUseCase
        self.userUseCase = userUseCase
    }
    
    func fetchMyData(followRelationType: FollowRelationType) async throws {
        switch followRelationType {
            case .unfollowing: // 팔로워
                let users = try await followRelationUseCase.fetchMyFollowerList()
                DispatchQueue.main.async {
                    self.users = users
                }
            case .following:  // 팔로잉
                let users = try await followRelationUseCase.fetchMyFollowingList()
                DispatchQueue.main.async {
                    self.users = users
                }
            }
    }
    
    func fetchFreindData(followRelationType: FollowRelationType, friendUserID: String) async throws {
        switch followRelationType {
            case .unfollowing: // 팔로워
                let users = try await followRelationUseCase.fetchFriendFollowerList(friendID: friendUserID)
                DispatchQueue.main.async {
                    self.users = users
                }
            case .following:  // 팔로잉
            let users = try await followRelationUseCase.fetchFriendFollowingList(friendID: friendUserID)
                DispatchQueue.main.async {
                    self.users = users
                }
            }
    }
}
