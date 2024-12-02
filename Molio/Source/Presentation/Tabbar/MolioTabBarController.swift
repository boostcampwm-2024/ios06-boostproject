import UIKit

final class MolioTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .main
        appearance.stackedLayoutAppearance.normal.iconColor = .white

        // 탭 바의 외형 설정
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        let customBackgroundView = UIView(frame: tabBar.bounds)
        customBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customBackgroundView.addGradientBackground()
        
        tabBar.insertSubview(customBackgroundView, at: 0)
    }
    
    private func setupViewControllers() {
        let swipeMusicViewController = createSwipeMusicViewController()
        let searchUserViewController = createSearchUserViewController()
        let communityViewController = createCommunityViewController()
        
        viewControllers = [
            swipeMusicViewController,
            searchUserViewController,
            communityViewController
        ]
    }
    
    private func createSwipeMusicViewController() -> UINavigationController {
        let swipeMusicViewModel = SwipeMusicViewModel()
        let swipeMusicViewController = SwipeMusicViewController(viewModel: swipeMusicViewModel)
        let navigationController = UINavigationController(rootViewController: swipeMusicViewController)
        swipeMusicViewController.tabBarItem.image = UIImage(systemName: "house.fill")
        return navigationController
    }
    
    private func createSearchUserViewController() -> UINavigationController {
        let searchUserViewController = SearchUserViewController()
        let navigationController = UINavigationController(rootViewController: searchUserViewController)
        searchUserViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        return navigationController
    }
    
    private func createCommunityViewController() -> UINavigationController {
        let communityViewController = CommunityViewController()
        let communityViewNavigationController = UINavigationController(rootViewController: communityViewController)
        communityViewController.tabBarItem.image = UIImage(systemName: "person.fill")
        return communityViewNavigationController
    }
}
