import SwiftUI

final class ExportPlaylistImageViewController: UIHostingController<ExportPlaylistImageView> {
    init(viewModel: ExportPlaylistImageViewModel) {
        let exportPlaylistImageView = ExportPlaylistImageView(viewModel: viewModel)
        super.init(rootView: exportPlaylistImageView)
        rootView.doneButtonTapAction = didTapDoneButton
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func didTapDoneButton() {
        dismiss(animated: true)
    }
}
