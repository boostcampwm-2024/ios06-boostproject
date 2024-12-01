import FirebaseAuth

/// 유저 플레이리스트를 동기화하는 객체
final class UserPlaylistSyncManager {
    private var playlistService: PlaylistService
    private var playlistStorage: PlaylistLocalStorage
    
    private var currentUserIDUseCase: CurrentUserIdUseCase

    init(
        playlistService: PlaylistService = DIContainer.shared.resolve(),
        playlistStorage: PlaylistLocalStorage = DIContainer.shared.resolve(),
        currentUserIDUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve()
    ) {
        self.playlistService = playlistService
        self.playlistStorage = playlistStorage
        self.currentUserIDUseCase = currentUserIDUseCase
    }
    
    func loginToLogoutLogic() async {
        do {
            // 0. 현재 유저의 ID를 가져온다.
            guard let userID = try currentUserIDUseCase.execute() else { return }

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
    
    func logoutToLoginLogic() async {
        do {
            // 0. 현재 유저의 ID를 가져온다.
            guard let userID = try currentUserIDUseCase.execute() else { return }

            // 1. 서버에 있는 플레이리스트를 전부 다 지워버린다.
            try await deleteAllPlaylistInServer()
            
            // 2. 로컬 스토리지에 있는 플레이리스트를 전부 가져온다.
            let userAllPlaylistsInStorage = try await playlistStorage.readAll()
            
            // 3. 로컬 스토리지에 있는 모든 플레이리스트를 서버에 저장한다.
            for playlist in userAllPlaylistsInStorage {
                let playlistDTO = MolioPlaylistMapper.map(from: playlist)
                
                try await playlistService.createPlaylist(playlist: playlistDTO)
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
    
    private func deleteAllPlaylistInServer() async throws {
        guard let userID = try currentUserIDUseCase.execute() else { return }
        
        let userAllPlaylistsInService = try await playlistService.readAllPlaylist(userID: userID)
        
        for playlist in userAllPlaylistsInService {
            guard let playlistUUID = UUID(uuidString: playlist.id) else { continue }
            
            try await playlistService.deletePlaylist(playlistID: playlistUUID)
        }
    }
}
