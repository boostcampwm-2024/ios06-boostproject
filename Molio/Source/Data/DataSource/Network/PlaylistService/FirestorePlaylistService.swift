final class FirestorePlaylistService: PlaylistService {
    private let firestoreManager: FirestoreManager
    private let loginManager: LoginManager
    
    init(
        firestoreManager: FirestoreManager = FirestoreManager(),
        loginManager: LoginManager = MockLoginManager(mockID: "mockID")
    ) {
        self.firestoreManager = firestoreManager
        self.loginManager = loginManager
    }
    
    // 추가하려면 유저 자체도 업데이트 해야 한다.
    func create(playlist: MolioPlaylist) async throws {
        guard let currentUserID = loginManager.getCurrentUserID() else {
            throw FirestoreError.notLoggedIn
        }
        
        guard let user = try await firestoreManager.read(entityType: MolioUser.self, id: currentUserID) else {
            throw FirestoreError.noSuchUserID
        }
        
        let newUserPlaylist = user.playlists + [playlist.id.uuidString]
        
        let newUser = user.copy(playlists: newUserPlaylist)
        
        try await firestoreManager.update(entity: newUser)
        
        try await firestoreManager.create(entity: playlist)
    }
    
    /// 이걸로 다른 유저의 playlistID도 읽어올 수 있기에 내 User에 그 플레이리스트가 속하는지 확인하지 않는다.
    func read(playlistID: String) async throws -> MolioPlaylist? {
        try await firestoreManager.read(entityType: MolioPlaylist.self, id: playlistID)
    }
    
    /// 현재 유저의 모든 플레이리스트를 읽어오는 메서드다.
    func readAll() async throws -> [MolioPlaylist] {
        guard let currentUserID = loginManager.getCurrentUserID() else {
            throw FirestoreError.notLoggedIn
        }
        
        guard let user = try await firestoreManager.read(entityType: MolioUser.self, id: currentUserID) else {
            throw FirestoreError.noSuchUserID
        }
        
        var result: [MolioPlaylist] = []

        for playlistID in user.playlists {
            if let playlist = try await firestoreManager.read(entityType: MolioPlaylist.self, id: playlistID) {
                result.append(playlist)
            }
        }
        
        return result
    }
        
    func update(playlist: MolioPlaylist) async throws {
        try await firestoreManager.update(entity: playlist)
    }
    
    func delete(playlistID: String) async throws {
        try await firestoreManager.delete(entityType: MolioPlaylist.self, idString: playlistID)
    }
}
