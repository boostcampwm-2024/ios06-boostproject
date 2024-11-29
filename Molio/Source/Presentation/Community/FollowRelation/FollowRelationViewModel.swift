import Combine
import SwiftUI


final class FollowRelationViewModel: ObservableObject {
    @Published var users: [MolioUser] = []
    private let followRelationUseCase: FollowRelationUseCase
    private let userUseCase: UserUseCase
    
    init(
        followRelationUseCase: FollowRelationUseCase, 
        userUseCase: UserUseCase
    ) {
        self.followRelationUseCase = followRelationUseCase
        self.userUseCase = userUseCase
    }
    
    func fecthData(followRelationType: FollowRelationType) async throws{
        switch followRelationType {
        case .unfollowing: // 팔로워
            let followerRelations = try await followRelationUseCase.fetchMyFollowerList()
        case .following:  // 팔로잉
            let followginRelations = try await followRelationUseCase.fetchMyFollowingList()
            
            let users = try await userUseCase.fetchUser(userID: <#T##String#>)
            DispatchQueue.main.async {
                self.users = users
            }
        }
    }
}
