import SwiftUI

final class UserProfileViewController: UIHostingController<UserProfileView> {
    private let viewModel: UserProfileViewModel
    private let followRelationViewModel: FollowRelationViewModel
    
    // MARK: - Initializer
    
    init(
        profileType: ProfileType
    ) {
        self.viewModel = UserProfileViewModel(profileType: profileType)
        self.followRelationViewModel = FollowRelationViewModel()
        let userProfileView = UserProfileView(viewModel: viewModel)
        
        super.init(rootView: userProfileView)
        
        rootView.didFollowerButtonTapped = { [weak self] profileType in
            guard let self = self else { return }
            self.navigationToFollowerListView()
        }
        
        rootView.didFollowingButtonTapped = { [weak self] profileType in
            guard let self = self else { return }
            self.navigationToFollowingListView()
        }
        
        rootView.didPlaylistCellTapped = { [weak self] playlist in
            guard let self = self else { return }
            self.navigationToFriendPlaylistListView(playlist: playlist)
        }
        
        rootView.didSettingButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToSettingViewController()
        }
        setupButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = UserProfileViewModel(profileType: .me)
        self.followRelationViewModel = FollowRelationViewModel()
        super.init(coder: aDecoder)
        
        setupButtonAction()
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private func
    
    private func navigateToSettingViewController() {
        let settingViewModel = SettingViewModel()
        let settingsViewController = SettingViewController(viewModel: settingViewModel)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func navigationToFollowingListView() {
        
        let followingListViewController = FollowRelationViewController(viewModel: followRelationViewModel, followRelationType: .following, friendUserID: nil)
        navigationController?.pushViewController(followingListViewController, animated: true)
    }
    
    private func navigationToFollowerListView() {
        let followerListViewController = FollowRelationViewController(viewModel: followRelationViewModel, followRelationType: .unfollowing, friendUserID: nil)
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
    
    private func navigationToFriendPlaylistListView(playlist: MolioPlaylist) {
        let friendPlaylistListViewController = FriendPlaylistDetailHostingViewController(playlist: playlist)
        navigationController?.pushViewController(friendPlaylistListViewController, animated: true)
    }
    private func setupButtonAction() {
        // /// navigate To SettingViewController
        // rootView.didSettingButtonTapped = { [weak self] in
        //     guard let self else { return }
        //     let settingViewModel = SettingViewModel()
        //     let settingsViewController = SettingViewController(viewModel: settingViewModel)
        //     self.navigationController?.pushViewController(settingsViewController, animated: true)
        // }
        
        // /// navigation To FollowerListView
        // rootView.didFollowerButtonTapped = { [weak self] in
        //     guard let self else { return }
        //     let followerListViewController = FollowRelationViewController(
        //         viewModel: followRelationViewModel,
        //         isMyProfile: true,
        //         followRelation: .unfollowing,
        //         friendUserID: nil
        //     )
        //     self.navigationController?.pushViewController(followerListViewController, animated: true)
        // }
        
        // /// navigation To FollowingListView
        // rootView.didFollowingButtonTapped = { [weak self] in
        //     guard let self else { return }
        //     let followingListViewController = FollowRelationViewController(
        //         viewModel: followRelationViewModel,
        //         isMyProfile: true,
        //         followRelation: .following,
        //         friendUserID: nil
        //     )
        //     self.navigationController?.pushViewController(followingListViewController, animated: true)
        // }
        
        // /// navigation To FriendPlaylistListView
        // rootView.didPlaylistCellTapped = { [weak self] playlist in
        //     guard let self else { return }
        //     let friendPlaylistListViewController = FriendPlaylistDetailHostingViewController(playlist: playlist)
        //     self.navigationController?.pushViewController(friendPlaylistListViewController, animated: true)
        // }
        
        rootView.didNotificationButtonTapped = { [weak self] in
            guard let self else { return }
            let notificationViewModel = NotificationViewModel()
            let notificationViewController = UIHostingController(rootView: NotificationView(viewModel: notificationViewModel))
            notificationViewController.title = "알림"
            self.navigationController?.pushViewController(notificationViewController, animated: true)
        }
    }
}

