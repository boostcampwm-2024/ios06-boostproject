import SwiftUI

final class OnBoardingExportViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBordingView = OnBoardingView(
            title: """
            몰리오에서 만들 플레이리스트를
            다른 플랫폼으로 내보낼 수 있어요!
            """,
            subTitle: 
            """
            애플 뮤직 을 구독하지 않은 경우에는
            플레이리스트를 사진으로 내보낼 수 있어요.
            """,
            image: Image(.onBoardingExport)
        )
        
        super.init(rootView: onBordingView)

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


