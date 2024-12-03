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
        
        rootView.didFollowerButtonTapped = { [weak self] profileType in
            guard let self = self else { return }
            self.navigationToFollowerListView(profileType: profileType)
        }
        
        rootView.didFollowingButtonTapped = { [weak self] profileType in
            guard let self = self else { return }
            self.navigationToFollowingListView(profileType: profileType)
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Present Sheet or Navigation
    
    private func navigationToFollowingListView(profileType: ProfileType) {
        var friendUserID: String?
        
        switch profileType {
        case .me:
            friendUserID = nil
        case .friend(let userID, let isFollowing):
            friendUserID = userID
        }
        
        let followingListViewController = FollowRelationViewController(viewModel: followRelationViewModel, followRelationType: .following, friendUserID: friendUserID)
        navigationController?.pushViewController(followingListViewController, animated: true)
    }
    
    private func navigationToFollowerListView(profileType: ProfileType) {
        var friendUserID: String?

        switch profileType {
        case .me:
            friendUserID = nil
        case .friend(let userID, let isFollowing):
            friendUserID = userID
        }
        
        let followerListViewController = FollowRelationViewController(viewModel: followRelationViewModel, followRelationType: .unfollowing, friendUserID: friendUserID)
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
    
    private func navigationToFriendPlaylistListView(playlist: MolioPlaylist) {
        let friendPlaylistListViewController = FriendPlaylistDetailHostingViewController(playlist: playlist)
        navigationController?.pushViewController(friendPlaylistListViewController, animated: true)
    }
}
