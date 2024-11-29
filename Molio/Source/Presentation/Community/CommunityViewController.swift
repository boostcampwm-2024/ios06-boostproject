import SwiftUI
import UIKit

final class CommunityViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserProfileView()
    }
    
    private func setupUserProfileView() {
        let viewModelForMyProfile = UserProfileViewModel(
            fetchPlaylistUseCase: DefaultFetchPlaylistUseCase(
                playlistRepisitory: DefaultPlaylistRepository(
                    playlistService: FirestorePlaylistService(),
                    playlistStorage: CoreDataPlaylistStorage()
                ),
                musicKitService: DefaultMusicKitService(),
                currentUserIDUseCase: DefaultCurrentUserIdUseCase(
                    authService: DefaultFirebaseAuthService(),
                    usecase: DefaultManageAuthenticationUseCase(
                        authStateRepository: DefaultAuthStateRepository()
                    )
                )
            ),
            currentUserIdUseCase: DefaultCurrentUserIdUseCase(
                authService: DefaultFirebaseAuthService(),
                usecase: DefaultManageAuthenticationUseCase(
                    authStateRepository: DefaultAuthStateRepository()
                )
            ),
            followRelationUseCase: DefaultFollowRelationUseCase(
                service: FirebaseFollowRelationService(),
                authService: DefaultFirebaseAuthService()
            ), userUseCase: DefaultUserUseCase(service: FirebaseUserService())
        )
        let userProfileView = UserProfileView(isMyProfile: true, viewModel: viewModelForMyProfile)
        
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
