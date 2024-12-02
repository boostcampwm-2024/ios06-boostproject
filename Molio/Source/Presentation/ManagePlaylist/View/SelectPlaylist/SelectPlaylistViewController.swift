import SwiftUI

final class SelectPlaylistViewController: UIHostingController<SelectPlaylistView> {
    weak var delegate: SelectPlaylistViewControllerDelegate?
    
    init(viewModel: ManagePlaylistViewModel, isCreatable: Bool = true) {
        let view = SelectPlaylistView(viewModel: viewModel, isCreatable: isCreatable)
        super.init(rootView: view)
        
        rootView.createButtonTapAction = { [weak self] in
            self?.dismiss(animated: true) {
                self?.delegate?.didTapCreateButton()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

protocol SelectPlaylistViewControllerDelegate: AnyObject {
    func didTapCreateButton()
}
