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
        
        rootView.didNotificationButtonTapped = { [weak self] in
            guard let self else { return }
            let notificationViewModel = NotificationViewModel()
            let notificationViewController = UIHostingController(rootView: NotificationView(viewModel: notificationViewModel))
            notificationViewController.title = "알림"
            self.navigationController?.pushViewController(notificationViewController, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = UserProfileViewModel(profileType: .me)
        self.followRelationViewModel = FollowRelationViewModel()
        super.init(coder: aDecoder)
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
        let useCase: CurrentUserIdUseCase = DIContainer.shared.resolve()
        
        do {
            let userID = try useCase.execute()
            
            // 사용자 ID에 따라 화면을 결정
            let viewController: UIViewController
            if playlist.authorID == userID {
                // 자신의 플레이리스트
                let myPlaylistViewModel = PlaylistDetailViewModel(currentPlaylist: playlist)
                viewController = PlaylistDetailViewController(viewModel: myPlaylistViewModel)
            } else {
                // 친구의 플레이리스트
                let friendPlaylistViewController = FriendPlaylistDetailHostingViewController(playlist: playlist)
                viewController = friendPlaylistViewController
            }
            
            // 네비게이션으로 이동
            navigationController?.pushViewController(viewController, animated: true)
            
        } catch {
            print("Error retrieving user ID: \(error.localizedDescription)")
        }
    }
   
}

