import Combine
import SwiftUI

final class FollowRelationViewModel: ObservableObject {
    @Published var users: [MolioFollower] = []
    private let followRelationUseCase: FollowRelationUseCase

    init(followRelationUseCase: FollowRelationUseCase = DIContainer.shared.resolve()) {
        self.followRelationUseCase = followRelationUseCase
    }
    
    func fetchData(followRelationType: FollowRelationType, friendUserID: String?) async throws {
        guard let friendUserID else {
            try await fetchMyData(followRelationType: followRelationType)
            return
        }
        try await fetchFriendData(followRelationType: followRelationType, friendUserID: friendUserID)
    }

    @MainActor
    private func fetchMyData(followRelationType: FollowRelationType) async throws {
        switch followRelationType {
        case .unfollowing: // 팔로워
            users = try await followRelationUseCase.fetchMyFollowerList()
            print(users)
        case .following: // 팔로잉
            users = try await followRelationUseCase.fetchMyFollowingList()
        }
    }
    
    @MainActor
    private func fetchFriendData(followRelationType: FollowRelationType, friendUserID: String) async throws {
        switch followRelationType {
        case .unfollowing: // 팔로워
            users = try await followRelationUseCase.fetchFriendFollowerList(friendID: friendUserID)
        case .following: // 팔로잉
            users = try await followRelationUseCase.fetchFriendFollowingList(friendID: friendUserID)
        }
    }
    
    /// 팔로우 상태 업데이트 메서드
    @MainActor
    func updateFollowState(for user: MolioFollower, to type: FollowRelationType, friendUserID: String?) async {
        do {
            // 서버에 팔로우 상태 업데이트
            switch type {
            case .following:
                try await followRelationUseCase.unFollow(to: user.id)
            case .unfollowing:
                try await followRelationUseCase.requestFollowing(to: user.id)
            }
            
            try await fetchData(followRelationType: type, friendUserID: friendUserID)
        } catch {
            print("Failed to update follow state: \(error.localizedDescription)")
        }
    }
}
