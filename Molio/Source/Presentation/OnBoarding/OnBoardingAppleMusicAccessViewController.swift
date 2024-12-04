import SwiftUI

final class OnBoardingAppleMusicAccessViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBoardingView = OnBoardingView(page: .seven)
        
        super.init(rootView: onBoardingView)

        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToLoginViewController()
            setIsOnboardedTrue()
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
    
    private func navigateToLoginViewController() {
        let loginViewController = LoginViewController(viewModel: LoginViewModel())

        guard let window = self.view.window else { return }
        
        UIView.transition(with: window, duration: 0.5) {
            loginViewController.view.alpha = 0.0
            window.rootViewController = loginViewController
            loginViewController.view.alpha = 1.0
        }
        
        window.makeKeyAndVisible()
    }
    
    private func setIsOnboardedTrue() {
        UserDefaults.standard.set(true, forKey: UserDefaultKey.isOnboarded.rawValue)
    }
}
