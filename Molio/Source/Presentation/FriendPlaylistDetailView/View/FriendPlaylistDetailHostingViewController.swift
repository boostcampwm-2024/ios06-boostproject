import Combine
import SwiftUI

final class FriendPlaylistDetailHostingViewController: UIHostingController<FriendPlaylistDetailView> {
    init(
        playlist: MolioPlaylist,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve()
    ) {
        let viewModel = FriendPlaylistDetailViewModel(
            friendPlaylist: playlist,
            fetchPlaylistUseCase: fetchPlaylistUseCase
        )

        let rootView = FriendPlaylistDetailView(
            viewModel: viewModel
        )
        
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
