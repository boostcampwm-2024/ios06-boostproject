import SwiftUI

final class OnBoardingAppleMusicAccessViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBordingView = OnBoardingView(
            title: """
            쉽고 빠르게 스와이프로
            내 취향인 노래를 저장해보세요!
            """,
            image: Image("")
        )
        
        super.init(rootView: onBordingView)

        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToSwipeMusicViewController()
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
    
    private func navigateToSwipeMusicViewController() {
        print("메인 화면으로 이동")
        // TODO: 메인 화면으로 이동하는 로직 추가 아예 rootView를 갈아 끼워야?
    }
    
}
