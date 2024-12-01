import AuthenticationServices
import SwiftUI

final class SettingViewController: UIHostingController<SettingView> {
    private var credentialCompletion: ((String, String) -> Void)?
    
    // MARK: - Initializer
    
    init(viewModel: SettingViewModel) {
        let settingView = SettingView(viewModel: viewModel)
        super.init(rootView: settingView)
        viewModel.delegate = self
        
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
        rootView.didTapMyInfoView = { [weak self] currentUserInfo  in
            guard let currentUserInfo = currentUserInfo else { return }
            let myInfoViewModel = MyInfoViewModel(currentUser: currentUserInfo)
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
            self?.switchToLoginViewController()
        }
        
        rootView.didTapDeleteAccountView = { [weak self] in
            self?.switchToLoginViewController()
        }
    }
    
    private func switchToLoginViewController() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        guard let window = self.view.window else { return }
        
        UIView.transition(with: window, duration: 0.5) {
            loginViewController.view.alpha = 0.0
            window.rootViewController = loginViewController
            loginViewController.view.alpha = 1.0
        }
        
        window.makeKeyAndVisible()
    }
}

extension SettingViewController: SettingViewModelDelegate {
    func requestAppleCredentials(completion: @escaping (String, String) -> Void) {
        self.credentialCompletion = completion
        setupAppleAuth()
    }
    
    private func setupAppleAuth() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension SettingViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = appleIDCredential.identityToken,
              let identityTokenString = String(data: identityToken, encoding: .utf8),
              let authorizationCode = appleIDCredential.authorizationCode,
              let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else { return }
        
        credentialCompletion?(identityTokenString, authorizationCodeString)
    }
}

extension SettingViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
