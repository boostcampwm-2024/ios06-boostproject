import Combine
import SwiftUI

final class FriendPlaylistDetailHostingViewController: UIHostingController<FriendPlaylistDetailView> {
    // MARK: - Initializer
    
    init(
        playlist: MolioPlaylist,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DefaultFetchPlaylistUseCase()
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
    
    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: FriendPlaylistDetailHostingViewController(playlist: .mock2))
}
