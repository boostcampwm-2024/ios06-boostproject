import SwiftUI

final class OnBoardingFilterViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBordingView = OnBoardingView(
            title: """
            원하는 장르를 선택하여
            나만의 플레이리스트를 만들어보세요!
            """,
            subTitle: "플레이리스트에 넣을 음악의 장르를 선택할 수 있어요.",
            image: Image(.onBoardingFilter)
        )
        
        super.init(rootView: onBordingView)

        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToOnBoardingExportViewController()
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
    
    private func navigateToOnBoardingExportViewController() {
        let viewController = OnBoardingExportViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
