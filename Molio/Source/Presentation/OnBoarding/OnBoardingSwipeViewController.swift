import SwiftUI

final class OnBoardingSwipeViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBoardingView = OnBoardingView(page: .two)
        super.init(rootView: onBoardingView)

        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToOnBoardingFilterViewController()
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
    
    private func navigateToOnBoardingFilterViewController() {
        let viewController = OnBoardingFilterViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
