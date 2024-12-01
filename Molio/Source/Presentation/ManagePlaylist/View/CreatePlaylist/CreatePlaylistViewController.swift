import SwiftUI

final class CreatePlaylistViewController: UIHostingController<CreatePlaylistView> {
    init(viewModel: ManagePlaylistViewModel) {
        let view = CreatePlaylistView(viewModel: viewModel)
        super.init(rootView: view)
        
        rootView.dismissAction = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
