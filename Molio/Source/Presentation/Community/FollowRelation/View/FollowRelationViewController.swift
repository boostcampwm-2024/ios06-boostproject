import SwiftUI

final class FollowRelationViewController: UIHostingController<FollowRelationListView> {
    private let viewModel: FollowRelationViewModel
    private let followRelationType: FollowRelationType
    private let friendUserID: String?
    // MARK: - Initializer
    
    init(viewModel: FollowRelationViewModel, followRelationType: FollowRelationType, friendUserID: String?) {
        self.viewModel = viewModel
        self.followRelationType = followRelationType
        self.friendUserID = friendUserID

        let followRelationListView = FollowRelationListView(
            viewModel: viewModel,
            followRelationType: followRelationType,
            friendUserID: friendUserID
        )
        super.init(rootView: followRelationListView)
        
        rootView.didUserInfoCellTapped = { [weak self] selectedUser in
            guard let self else { return }
            self.navigateTofriendViewController(with: selectedUser)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch followRelationType {
        case .unfollowing:
            navigationItem.title = "팔로워"
        case .following:
            navigationItem.title = "팔로잉"
        }
    }
    
    // MARK: - Present Sheet or Navigation
    
    private func navigateTofriendViewController(with user: MolioFollower) {
        let useCase: CurrentUserIdUseCase = DIContainer.shared.resolve()
        
        do {
            let userID = try useCase.execute()
            
            // 사용자 ID에 따라 화면을 결정
            let viewController: UIViewController
            if user.id == userID {
                // 자신의 플레이리스트
                viewController = UserProfileViewController(profileType: .me)
            } else {
                // 친구의 프로필
                viewController = FriendProfileViewController(
                    profileType: .friend(
                        userID: user.id,
                        isFollowing: user.followRelation
                    )
                )
            }
            
            // 네비게이션으로 이동
            navigationController?.pushViewController(viewController, animated: true)
            
        } catch {
            print("Error retrieving user ID: \(error.localizedDescription)")
        }
       
    }
}
