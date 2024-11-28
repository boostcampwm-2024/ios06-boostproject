import SwiftUI

final class SettingViewController: UIHostingController<SettingView> {
    // MARK: - Initializer
    
    init(viewModel: SettingViewModel) {
        let settingView = SettingView(viewModel: viewModel)
        super.init(rootView: settingView)
        
        setupButtonAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "설정"
    }
    
    // MARK: - Private func
    
    private func setupButtonAction() {
        rootView.didTapMyInfoView = { [weak self] in
            let myInfoViewModel = MyInfoViewModel()
            let myInfoViewController = MyInfoViewController(viewModel: myInfoViewModel)
            self?.navigationController?.pushViewController(myInfoViewController, animated: true)
        }
        
        rootView.didTapTermsAndConditionView = { [weak self] in
            let termsAndConditionViewController = UIHostingController(rootView: TermsAndConditionView())
            termsAndConditionViewController.title = "약관 및 개인 정보 처리 동의"
            self?.navigationController?.pushViewController(termsAndConditionViewController, animated: true)
        }
        
        rootView.didTapPrivacyPolicyView = { [weak self] in
            let privacyPolicyViewController = UIHostingController(rootView: PrivacyPolicyView())
            privacyPolicyViewController.title = "개인정보 처리방침"
            self?.navigationController?.pushViewController(privacyPolicyViewController, animated: true)
        }
        
        rootView.didTapLoginView = { [weak self] in
            let loginViewModel = LoginViewModel()
            let loginViewController = LoginViewController(viewModel: loginViewModel)
            self?.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
}
