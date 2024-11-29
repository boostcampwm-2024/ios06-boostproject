import SwiftUI
import UIKit

final class CommunityViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfileView()
    }
    
    private func setupUserProfileView() {
        let userProfileView = UserProfileView(isMyProfile: true)
        
        let hostingController = UIHostingController(rootView: userProfileView)
        
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
