import SwiftUI

final class UserProfileViewController: UIHostingController<UserProfileView> {
    private let viewModel: UserProfileViewModel
    private let followRelationViewModel: FollowRelationViewModel
    
    private let isMyProfile: Bool
    private let followRelation: FollowRelationType?
    private let friendUserID: String?
    
    // MARK: - Initializer
    
    init(
        viewModel: UserProfileViewModel,
        followRelationViewModel: FollowRelationViewModel,
        isMyProfile: Bool,
        followRelation: FollowRelationType?,
        friendUserID: String?
    ) {
        self.viewModel = viewModel
        self.followRelationViewModel = followRelationViewModel
        self.isMyProfile = isMyProfile
        self.followRelation = followRelation
        self.friendUserID = friendUserID
        
        let userProfileView = UserProfileView(
            isMyProfile: isMyProfile,
            followRelationType: followRelation,
            viewModel: viewModel,
            friendUserID: friendUserID
        )
        super.init(rootView: userProfileView)
        
        setupButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isMyProfile = false
        self.followRelation = nil
        self.friendUserID = nil
        
        self.viewModel = UserProfileViewModel()
        self.followRelationViewModel = FollowRelationViewModel()
        super.init(coder: aDecoder)
        
        setupButtonAction()
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Private func
    
    private func setupButtonAction() {
        /// navigate To SettingViewController
        rootView.didSettingButtonTapped = { [weak self] in
            guard let self else { return }
            let settingViewModel = SettingViewModel()
            let settingsViewController = SettingViewController(viewModel: settingViewModel)
            self.navigationController?.pushViewController(settingsViewController, animated: true)
        }
        
        /// navigation To FollowerListView
        rootView.didFollowerButtonTapped = { [weak self] in
            guard let self else { return }
            let followerListViewController = FollowRelationViewController(
                viewModel: followRelationViewModel,
                isMyProfile: true,
                followRelation: .unfollowing,
                friendUserID: nil
            )
            self.navigationController?.pushViewController(followerListViewController, animated: true)
        }
        
        /// navigation To FollowingListView
        rootView.didFollowingButtonTapped = { [weak self] in
            guard let self else { return }
            let followingListViewController = FollowRelationViewController(
                viewModel: followRelationViewModel,
                isMyProfile: true,
                followRelation: .following,
                friendUserID: nil
            )
            self.navigationController?.pushViewController(followingListViewController, animated: true)
        }
        
        /// navigation To FriendPlaylistListView
        rootView.didPlaylistCellTapped = { [weak self] playlist in
            guard let self else { return }
            let friendPlaylistListViewController = FriendPlaylistDetailHostingViewController(playlist: playlist)
            self.navigationController?.pushViewController(friendPlaylistListViewController, animated: true)
        }
    }
}
