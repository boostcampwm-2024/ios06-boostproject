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
        let viewModel = FriendPlaylistDetailViewModel(friendPlaylist: playlist, fetchPlaylistUseCase: fetchPlaylistUseCase)

        var rootView = FriendPlaylistDetailView(
            viewModel: viewModel
        )
        
        super.init(rootView: rootView)

        rootView.exportFriendsMusicToMyPlaylistDelegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension FriendPlaylistDetailHostingViewController: ExportFriendsMusicToMyPlaylistDelegate {
    func exportFriendsMusicToMyPlaylist(molioMusic: MolioMusic) {
        // 친구의 음악을 내 플레이리스트에 추가하는 시트 생성
        let selectPlaylistView = SelectPlaylistToExportFriendMusicView(
            viewModel: SelectPlaylistToExportFriendMusicViewModel(
                selectedMusic: molioMusic
            )
        )
        self.presentCustomSheet(content: selectPlaylistView)
    }
}
