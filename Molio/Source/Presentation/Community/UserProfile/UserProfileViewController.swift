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
        
        let userProfileView = UserProfileView(isMyProfile: isMyProfile, followRelationType: followRelation, viewModel: viewModel, friendUserID: friendUserID)
        super.init(rootView: userProfileView)
        
        rootView.didSettingButtonTapped = navigateToSettingViewController
        rootView.didFollowerButtonTapped = navigationToFollowerListView
        rootView.didFollowingButtonTapped = navigationToFollowingListView
        rootView.didPlaylistCellTapped = navigationToFriendPlaylistListView
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isMyProfile = false
        self.followRelation = nil
        self.friendUserID = nil
        
        self.viewModel = UserProfileViewModel()
        self.followRelationViewModel = FollowRelationViewModel()
        super.init(coder: aDecoder)
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
    
    // MARK: - Present Sheet or Navigation
    
    private func navigateToSettingViewController() {
        let settingViewModel = SettingViewModel()
        let settingsViewController = SettingViewController(viewModel: settingViewModel)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func navigationToFollowingListView() {
       
        let followingListViewController = FollowRelationViewController(viewModel: followRelationViewModel, isMyProfile: true, followRelation: .following, friendUserID: nil)
        navigationController?.pushViewController(followingListViewController, animated: true)
    }
    
    private func navigationToFollowerListView() {
        let followerListViewController = FollowRelationViewController(viewModel: followRelationViewModel, isMyProfile: true, followRelation: .unfollowing, friendUserID: nil)
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
    
    private func navigationToFriendPlaylistListView(playlist: MolioPlaylist) {
        let friendPlaylistListViewController = FriendPlaylistDetailHostingViewController(playlist: playlist)
        navigationController?.pushViewController(friendPlaylistListViewController, animated: true)
    }
}
