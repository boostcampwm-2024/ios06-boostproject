import SwiftUI

final class OnBoardingPlaylistViewController: UIHostingController<OnBoardingView> {
    // MARK: - Initializer
    
    init() {
        let onBoardingView = OnBoardingView(page: .one)
        super.init(rootView: onBoardingView)
        
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
