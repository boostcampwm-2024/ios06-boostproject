import UIKit
import SwiftUI

final class CommunityViewController: UIViewController {
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfileView()
    }
    
    private func setupUserProfileView() {
        let userProfileViewController = UserProfileViewController(profileType: .me)
        
        addChild(userProfileViewController)
        view.addSubview(userProfileViewController.view)
        
        userProfileViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userProfileViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userProfileViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userProfileViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            userProfileViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        userProfileViewController.didMove(toParent: self)
    }
}
