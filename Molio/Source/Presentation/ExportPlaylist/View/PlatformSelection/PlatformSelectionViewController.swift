import SwiftUI

final class PlatformSelectionViewController: UIHostingController<PlatformSelectionView> {
    weak var delegate: PlatformSelectionViewControllerDelegate?
    
    init(viewModel: PlaylistDetailViewModel) {
        let platformSelectionView = PlatformSelectionView(viewModel: viewModel)
        super.init(rootView: platformSelectionView)
        
        rootView.exportButtonTapAction = { [weak self] platform in
            self?.delegate?.didSelectPlatform(with: platform)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

protocol PlatformSelectionViewControllerDelegate: AnyObject {
    func didSelectPlatform(with platform: ExportPlatform)
}
