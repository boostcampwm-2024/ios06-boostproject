import UIKit
import SwiftUI

final class CommunityViewController: UIViewController {
    // MARK: - Life Cycle
    
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
                authService: DefaultFirebaseAuthService(), userUseCase: DefaultUserUseCase(service: FirebaseUserService())
            ), userUseCase: DefaultUserUseCase(service: FirebaseUserService())
        )
        let followRelationViewModel = FollowRelationViewModel(
            followRelationUseCase: DefaultFollowRelationUseCase(
                service: FirebaseFollowRelationService(),
                authService: DefaultFirebaseAuthService(),
                userUseCase: DefaultUserUseCase(
                    service: FirebaseUserService())
            ),
            userUseCase: DefaultUserUseCase(
                service: FirebaseUserService())
        )
        
        let userProfileViewController = UserProfileViewController(
            viewModel: viewModelForMyProfile, 
            followRelationViewModel: followRelationViewModel,
            isMyProfile: true,
            followRelation: nil,
            friendUserID: nil
        )
        
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
