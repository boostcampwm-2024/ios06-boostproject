import FirebaseAuth
import Combine

/// 유저 플레이리스트를 동기화하는 객체
final class UserPlaylistSyncManager {
    private var playlistService: PlaylistService
    private var playlistStorage: PlaylistLocalStorage
    
    private var currentUserIDUseCase: CurrentUserIdUseCase
    
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private var subscriptions = Set<AnyCancellable>()

    private var currentUser = CurrentValueSubject<String?, Never>(nil)
    
    init(
        playlistService: PlaylistService = DIContainer.shared.resolve(),
        playlistStorage: PlaylistLocalStorage = DIContainer.shared.resolve(),
        currentUserIDUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve()
    ) {
        self.playlistService = playlistService
        self.playlistStorage = playlistStorage
        self.currentUserIDUseCase = currentUserIDUseCase
        
        self.authStateDidChangeListenerHandle = setLoginStatusListener()
        self.setUpBinding()
    }
    
    deinit {
        if let handle = self.authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        self.subscriptions.forEach { $0.cancel() }
    }
    
    // 이전 이후 값을 기록해서, 이전 이후가 로그인 - 로그아웃 상태가 변화한 경우에 알맞은 로직을 수행한다.
    // 그러기 위해서 CurrentValueSubject를 사용했다.
    // 이전 이후 값을 추적하기 위해서 맨 처음에는 (initialUserIDString, initialUserIDString)로 초기화하는 점이 중요하다.
    private func setUpBinding() {
        let initialUserIDString = Auth.auth().currentUser?.uid
        
        currentUser
            .scan((initialUserIDString, initialUserIDString)) { previous, newValue in
                return (previous.1, newValue)
            }
            .sink { [weak self] previous, newValue in
                guard let self = self else { return }
                
                performSyncLogic(beforeUserID: previous, afterUserID: newValue)
                
            }
            .store(in: &subscriptions)
    }
    
    private func performSyncLogic(beforeUserID: String?, afterUserID: String?) {
        switch (beforeUserID, afterUserID) {
        case (.none, .some(let loggedInUserID)):
            // 로그아웃 -> 로그인
            Task {
                await self.logoutToLoginLogic(userID: loggedInUserID)
            }
        case (.some(let loggedOutUserID), .none):
            // 로그인 -> 로그아웃
            Task {
                await self.loginToLogoutLogic(userID: loggedOutUserID)
            }
        default:
            break
        }
    }
    
    private func setLoginStatusListener() -> AuthStateDidChangeListenerHandle{
        return Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser.send(user?.uid)
        }
    }
    
    private func loginToLogoutLogic(userID: String) async {
        print("로그인 -> 로그아웃 로직 수행")
        do {
            // 1. 로컬 스토어의 플레이리스트를 전부 다 지워버린다.
            try await deleteAllPlaylistInLocalStorage()
            
            // 2. 서버에 있는 모든 플레이리스트를 가져온다.
            let userAllPlaylistsInService = try await playlistService.readAllPlaylist(userID: userID)
            
            // 3. 서버에 있는 플레이리스트를 로컬 스토리지에 저장한다.
            for playlist in userAllPlaylistsInService {
                let playlistEntity = MolioPlaylistMapper.map(from: playlist)
                try await playlistStorage.create(playlistEntity)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func logoutToLoginLogic(userID: String) async {
        print("로그아웃 -> 로그인 로직 수행")
        do {
            // 1. 서버에 있는 플레이리스트를 전부 다 지워버린다.
            try await deleteAllPlaylistInServer(userID: userID)
            
            // 2. 로컬 스토리지에 있는 플레이리스트를 전부 가져온다.
            let userAllPlaylistsInStorage = try await playlistStorage.readAll()
            
            // 3. 로컬 스토리지에 있는 모든 플레이리스트를 서버에 저장한다.
            for playlist in userAllPlaylistsInStorage {
                let playlistDTO = MolioPlaylistMapper.map(from: playlist)
                
                // 이때 AuthorID를 달아줘야 한다!!!
                let authorIDChangedPlaylistDTO = playlistDTO.copy(authorID: userID)
                
                try await playlistService.createPlaylist(playlist: authorIDChangedPlaylistDTO)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteAllPlaylistInLocalStorage() async throws {
        let userAllPlaylistsInStorage = try await playlistStorage.readAll()
        
        for playlist in userAllPlaylistsInStorage {
            try await playlistStorage.delete(by: playlist.id.uuidString)
        }
    }
    
    private func deleteAllPlaylistInServer(userID: String) async throws {
        let userAllPlaylistsInService = try await playlistService.readAllPlaylist(userID: userID)
        
        for playlist in userAllPlaylistsInService {
            guard let playlistUUID = UUID(uuidString: playlist.id) else { continue }
            
            try await playlistService.deletePlaylist(playlistID: playlistUUID)
        }
    }
}
