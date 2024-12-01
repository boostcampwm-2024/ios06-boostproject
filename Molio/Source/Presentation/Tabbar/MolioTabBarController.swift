import UIKit

final class MolioTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupTabBarAppearance()
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
        
        swipeMusicViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house.fill"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        return navigationController
    }
    
    private func createSearchUserViewController() -> UINavigationController {
        let searchUserViewController = SearchUserViewController()
        let navigationController = UINavigationController(rootViewController: searchUserViewController)
        
        searchUserViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        return navigationController
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
