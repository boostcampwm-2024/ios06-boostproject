import UIKit
import AVFAudio

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        configureAudioSession()
        setupNavigationBarAppearance()
        let splashViewController = SplashViewController(viewModel: SplahViewModel())
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: splashViewController)
        window?.makeKeyAndVisible()
    }
    
    // 오디션 세션 활성화
    private func configureAudioSession() {
        if !AVAudioSession.accessibilityActivate() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, 
                                                                mode: .default,
                                                                options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set up audio session: \(error)") //  TODO: 에러 알림창으로 표시하기
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = .main
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func switchToLoginViewController() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(viewModel: loginViewModel)

        guard let window = self.window else { return }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = loginViewController
        }, completion: nil)
        
        window.makeKeyAndVisible()
    }
}
