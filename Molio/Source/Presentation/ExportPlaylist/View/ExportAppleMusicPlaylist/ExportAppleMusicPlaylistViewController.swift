import SwiftUI

final class ExportAppleMusicPlaylistViewController: UIHostingController<ExportAppleMusicPlaylistView> {
    init(viewModel: PlaylistDetailViewModel) {
        let exportAppleMusicPlaylistView = ExportAppleMusicPlaylistView(viewModel: viewModel)
        super.init(rootView: exportAppleMusicPlaylistView)
        
        rootView.confirmButtonTapAction = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
