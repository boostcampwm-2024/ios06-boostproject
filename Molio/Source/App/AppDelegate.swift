import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let container = DIContainer.shared
        
        container.register(NetworkProvider.self, dependency: DefaultNetworkProvider())
        container.register(SpotifyTokenProvider.self, dependency: DefaultSpotifyTokenProvider())
        container.register(ImageFetchService.self, dependency: DefaultImageFetchService())
        container.register(SpotifyAPIService.self, dependency: MockSpotifyAPIService())
        container.register(MusicKitService.self, dependency: DefaultMusicKitService())
        container.register(AuthService.self, dependency: DefaultFirebaseAuthService())
        container.register(AuthLocalStorage.self, dependency: DefaultAuthLocalStorage())
        container.register(UserService.self, dependency: FirebaseUserService())
        container.register(PlaylistService.self, dependency: FirestorePlaylistService())
        container.register(PlaylistLocalStorage.self, dependency: CoreDataPlaylistStorage())
        
        // Repository
        container.register(RecommendedMusicRepository.self, dependency: DefaultRecommendedMusicRepository())
        container.register(ImageRepository.self, dependency: DefaultImageRepository())
        container.register(CurrentPlaylistRepository.self, dependency: DefaultCurrentPlaylistRepository())
        container.register(PlaylistRepository.self, dependency: MockPlaylistRepository())
        container.register(AuthStateRepository.self, dependency: DefaultAuthStateRepository())
        container.register(RealPlaylistRepository.self, dependency: DefaultPlaylistRepository())
        
        // UseCase
        container.register(FetchRecommendedMusicUseCase.self, dependency: DefaultFetchRecommendedMusicUseCase())
        container.register(FetchImageUseCase.self, dependency: DefaultFetchImageUseCase())
        container.register(FetchAvailableGenresUseCase.self, dependency: DefaultFetchAvailableGenresUseCase())
        container.register(CreatePlaylistUseCase.self, dependency: DefaultCreatePlaylistUseCase())
        container.register(AudioPlayer.self, dependency: SwipeMusicPlayer())
        container.register(ManageAuthenticationUseCase.self, dependency: DefaultManageAuthenticationUseCase())
        container.register(AppleMusicUseCase.self, dependency: DefaultAppleMusicUseCase())
        container.register(CurrentUserIdUseCase.self, dependency: DefaultCurrentUserIdUseCase())
        container.register(UserUseCase.self, dependency: DefaultUserUseCase())
        container.register(FetchPlaylistUseCase.self, dependency: DefaultFetchPlaylistUseCase())
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
