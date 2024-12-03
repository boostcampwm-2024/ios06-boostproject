import SwiftUI

final class OnBoardingCommunityViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBordingView = OnBoardingView(
            title: """
            내 친구의 플레이리스트를
            구경할 수 있어요!
            """,
            image: Image("onBoardingCommunity")
        )
        
        super.init(rootView: onBordingView)

        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToOnBoardingFriendPlaylistViewController()
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
    
    private func navigateToOnBoardingFriendPlaylistViewController() {
        let viewController = OnBoardingFriendPlaylistViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}



