import SwiftUI

final class OnBoardingFriendPlaylistViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBordingView = OnBoardingView(
            title: """
            친구의 플레이리스트에서
            마음에 드는 노래를 가져올 수 있어요!
            """,
            image: Image(.onBoardingFriendPlaylist)
        )
        
        super.init(rootView: onBordingView)

        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToOnBoardingAppleMusicAccessViewController()
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
    
    private func navigateToOnBoardingAppleMusicAccessViewController() {
        let viewController = OnBoardingAppleMusicAccessViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
