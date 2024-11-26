import UIKit

final class MolioTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarFrame()
    }
    
    private func setupTabBarFrame() {
        let safeAreaHeight = view.safeAreaInsets.bottom
        let tabBarHeight: CGFloat = 61
        tabBar.frame.size.height = tabBarHeight + safeAreaHeight
        tabBar.frame.origin.y = view.frame.height - tabBarHeight - safeAreaHeight
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        appearance.stackedLayoutAppearance.selected.iconColor = .main
        appearance.stackedLayoutAppearance.normal.iconColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.itemPositioning = .centered
    }
    
    private func setupViewControllers() {
        let swipeMusicViewController = createSwipeMusicViewController()
        let communityViewController = createCommunityViewController()
        
        viewControllers = [
            swipeMusicViewController,
            communityViewController
        ]
    }
    
    private func createSwipeMusicViewController() -> UINavigationController {
        let swipeMusicViewModel = SwipeMusicViewModel()
        let swipeMusicViewController = SwipeMusicViewController(viewModel: swipeMusicViewModel)
        let swipeMusicViewNavigationController = UINavigationController(rootViewController: swipeMusicViewController)
        
        swipeMusicViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house.fill"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        return swipeMusicViewNavigationController
    }
    
    private func createCommunityViewController() -> UINavigationController {
        let communityViewController = CommunityViewController()
        let communityViewNavigationController = UINavigationController(rootViewController: communityViewController)
        communityViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .personCircle).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .personCircle).withRenderingMode(.alwaysOriginal)
        )
        
        return communityViewNavigationController
    }
}
