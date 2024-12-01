import SwiftUI

final class FriendProfileViewController: UIHostingController<UserProfileView> {
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
        
        rootView.didFollowerButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigationToFollowerListView()
        }
        
        rootView.didFollowingButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigationToFollowingListView()
        }
        
        rootView.didPlaylistCellTapped = { [weak self] playlist in
            guard let self = self else { return }
            self.navigationToFriendPlaylistListView(playlist: playlist)
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Present Sheet or Navigation
    
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
