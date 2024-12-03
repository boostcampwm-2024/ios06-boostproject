import FirebaseAuth
import Combine

/// 유저 플레이리스트를 동기화하는 객체
///
/// DIContainer에 등록하기만 하면 사용할 수 있습니다.
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
    
    // 이전, 이후 상태를 기록해서 처리하기 위해서 CurrentValueSubject를 사용합니다.
    // 그리고 Source of Truth인 현재 로그인 상태는 `Auth.auth().addStateDidChangeListener` ㅇ 옵니다.
    // 이거는 로그인 변화를 감지해서 실행하는 리스너입니다. (탈퇴 포함)
    private func setLoginStatusListener() -> AuthStateDidChangeListenerHandle {
        return Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser.send(user?.uid)
        }
    }
    
    /// 이전 유저 ID, 이후 유저 ID 라는 것이 존재합니다.
    /// 두 칸 다 맨 처음에는 현재 유저로 초기화 합니다.
    /// 그리고 새로운 값이 들어 올 때마다 이전 상태를 현재 상태로 옮기고, 새로운 값은 이후 상태로 옮깁니다.
    private func setUpBinding() {
        let initialUserIDString = Auth.auth().currentUser?.uid
        
        currentUser
            .scan((initialUserIDString, initialUserIDString)) { previous, newValue in
                return (previous.1, newValue)
            }
            .sink { [weak self] previous, newValue in
                self?.performSyncLogic(beforeUserID: previous, afterUserID: newValue)
            }
            .store(in: &subscriptions)
    }
    
    /// 이전 유저 ID, 이후 유저 ID를 비교해서 로직을 수행합니다.
    private func performSyncLogic(beforeUserID: String?, afterUserID: String?) {
        Task { [weak self] in
            do {
                switch (beforeUserID, afterUserID) {
                // 로그아웃 -> 로그인
                case (.none, .some(let loggedInUserID)):
                    try await self?.logoutToLoginLogic(userID: loggedInUserID)
                // 로그인 -> 로그아웃
                case (.some(let loggedOutUserID), .none):
                    try await self?.loginToLogoutLogic(userID: loggedOutUserID)
                default:
                    break
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
        
    // MARK: - 로그인 <-> 로그아웃 시 실행하는 로직
    
    private func loginToLogoutLogic(userID: String) async throws {
        debugPrint("로그인 -> 로그아웃 로직 수행")

        // 1. 로컬 스토어의 플레이리스트를 전부 다 지워버린다.
        try await deleteAllPlaylistInLocalStorage()
        
        // 2. 서버에 있는 모든 플레이리스트를 가져온다.
        let userAllPlaylistsInService = try await playlistService.readAllPlaylist(userID: userID)
        
        // 3. 서버에 있는 플레이리스트를 로컬 스토리지에 저장한다.
        for playlist in userAllPlaylistsInService {
            let playlistEntity = MolioPlaylistMapper.map(from: playlist)
            
            try await playlistStorage.create(playlistEntity)
        }
    }
    
    private func logoutToLoginLogic(userID: String) async throws {
        debugPrint("로그아웃 -> 로그인 로직 수행")
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
