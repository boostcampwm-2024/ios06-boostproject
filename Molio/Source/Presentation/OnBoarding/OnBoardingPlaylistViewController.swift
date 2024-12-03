import SwiftUI

final class OnBoardingPlaylistViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBordingView = OnBoardingView(
            title: "나만의 플레이리스트를 만들어볼까요?",
            subTitle: """
                          몰리오는 기본 플레이리스트를 제공해요!
                          내가 원하는 테마, 분위기에 따라 플리를 생성할 수 있어요.
                          """,
            image: Image(.onBoardingPlaylist)
        )
        super.init(rootView: onBordingView)
        
        rootView.didButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.navigateToOnBoardingSwipeViewController()
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
    
    private func navigateToOnBoardingSwipeViewController() {
        let viewController = OnBoardingSwipeViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Preview

struct OnBoardingPlaylistViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> OnBoardingPlaylistViewController {
        return OnBoardingPlaylistViewController()
    }
    
    func updateUIViewController(_ uiViewController: OnBoardingPlaylistViewController, context: Context) { }
}

#Preview {
    OnBoardingPlaylistViewControllerPreview()
        .edgesIgnoringSafeArea(.all)
}
