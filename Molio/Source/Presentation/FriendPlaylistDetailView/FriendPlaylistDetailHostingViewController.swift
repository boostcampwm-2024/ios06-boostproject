import UIKit
import SwiftUI
import Combine

//func showFriendPlaylistDetail(friendUserID: String) {
//    let viewController = FriendPlaylistDetailHostingViewController(friendUserID: friendUserID)
//    navigationController?.pushViewController(viewController, animated: true)
//}

final class FriendPlaylistDetailHostingViewController: UIHostingController<FriendPlaylistDetailView> {
    init(
        playlist: MolioPlaylist,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DefaultFetchPlaylistUseCase()
    ) {
        let viewModel = FriendPlaylistDetailViewModel(
            friendPlaylist: playlist,
            fetchPlaylistUseCase: fetchPlaylistUseCase
        )

        let rootView = FriendPlaylistDetailView(viewModel: viewModel)
        
        super.init(rootView: rootView)
        
        viewModel.setDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: FriendPlaylistDetailHostingViewController(playlist: .mock2))
}
