import SwiftUI

final class OnBoardingExportViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBoardingView = OnBoardingView(page: .four)
        
        super.init(rootView: onBoardingView)
        
        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToOnBoardingCommunityViewController()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private func
    
    private func navigateToOnBoardingCommunityViewController() {
        let viewController = OnBoardingCommunityViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
