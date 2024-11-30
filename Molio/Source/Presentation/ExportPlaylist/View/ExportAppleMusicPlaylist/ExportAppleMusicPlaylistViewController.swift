import SwiftUI

final class ExportAppleMusicPlaylistViewController: UIHostingController<ExportAppleMusicPlaylistView> {
    init(viewModel: PlaylistDetailViewModel) {
        let exportAppleMusicPlaylistView = ExportAppleMusicPlaylistView(viewModel: viewModel)
        super.init(rootView: exportAppleMusicPlaylistView)
        
        rootView.confirmButtonTapAction = didTapConfirmButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func didTapConfirmButton() {
        dismiss(animated: true)
    }
}
