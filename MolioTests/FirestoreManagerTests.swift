import XCTest
@testable import Molio

final class FirestoreManagerTests: XCTestCase {
    var firestoreManager: FirestoreManager!
    var createdPlaylist: [MolioPlaylist] = []

    override func setUp() async throws {
        try await super.setUp()
        self.firestoreManager = FirestoreManager()
        self.createdPlaylist = []
    }

    override func tearDown() async throws {
        // 테스트에서 생성된 엔티티들을 삭제
        for createdEntity in self.createdPlaylist {
            try await self.firestoreManager.delete(entityType: MolioPlaylist.self, idString: createdEntity.idString)
        }
        
        self.firestoreManager = nil
        self.createdPlaylist = []
        
        try await super.tearDown()
    }

    func testCreatePlaylist() async throws {
        let playlist = MolioPlaylist(id: UUID(), name: "test", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        
        try await self.firestoreManager.create(entity: playlist)
        
        // 생성된 플레이리스트의 ID를 저장하여 나중에 삭제
        self.createdPlaylist.append(playlist)
        
        XCTAssertNotNil(playlist)
    }

    func testReadPlaylist() async throws {
        // Given: 새로운 플레이리스트 생성
        let playlistID = UUID()
        
        let playlist = MolioPlaylist(id: playlistID, name: "Test Playlist", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        
        // When: 플레이리스트를 Firestore에 저장
        try await self.firestoreManager.create(entity: playlist)
        
        // 생성된 플레이리스트의 ID를 저장하여 나중에 삭제
        self.createdPlaylist.append(playlist)
        
        // Then: Firestore에서 플레이리스트를 다시 읽어옴
        let fetchedPlaylist = try await self.firestoreManager.read(entityType: MolioPlaylist.self, id: playlistID.uuidString)
        
        // Assert: 가져온 플레이리스트가 nil이 아니고 원본과 일치하는지 확인
        XCTAssertNotNil(fetchedPlaylist, "가져온 플레이리스트는 nil이 아니어야 합니다")
        XCTAssertEqual(fetchedPlaylist?.id, playlist.id, "가져온 플레이리스트의 ID는 원본과 일치해야 합니다")
        XCTAssertEqual(fetchedPlaylist?.name, playlist.name, "가져온 플레이리스트의 이름은 원본과 일치해야 합니다")
        XCTAssertEqual(fetchedPlaylist?.createdAt.timeIntervalSince1970 ?? 0, playlist.createdAt.timeIntervalSince1970, accuracy: TimeInterval(1), "가져온 플레이리스트의 생성 날짜는 원본과 일치해야 합니다")
    }

    func testReadAllPlaylist() async throws {
        // Given: 여러 개의 플레이리스트 생성
        let playlist1 = MolioPlaylist(id: UUID(), name: "Playlist 1", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        let playlist2 = MolioPlaylist(id: UUID(), name: "Playlist 2", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        
        // When: 플레이리스트를 Firestore에 저장
        try await self.firestoreManager.create(entity: playlist1)
        try await self.firestoreManager.create(entity: playlist2)
        
        // 생성된 플레이리스트들의 ID를 저장하여 나중에 삭제
        self.createdPlaylist.append(playlist1)
        self.createdPlaylist.append(playlist2)
        
        // Then: Firestore에서 모든 플레이리스트를 읽어옴
        let fetchedPlaylists = try await self.firestoreManager.readAll(entityType: MolioPlaylist.self)
        
        // Assert: 가져온 플레이리스트가 우리가 생성한 플레이리스트를 포함하는지 확인
        XCTAssertNotNil(fetchedPlaylists)
        XCTAssertTrue(fetchedPlaylists.contains(where: { $0.id == playlist1.id }), "가져온 플레이리스트는 playlist1을 포함해야 합니다")
        XCTAssertTrue(fetchedPlaylists.contains(where: { $0.id == playlist2.id }), "가져온 플레이리스트는 playlist2를 포함해야 합니다")
    }

    func testUpdatePlaylist() async throws {
        // Given: 새로운 플레이리스트 생성 및 저장
        let playlistID = UUID()
        let playlist = MolioPlaylist(id: playlistID, name: "Original Name", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        try await self.firestoreManager.create(entity: playlist)
        
        // 생성된 플레이리스트의 ID를 저장하여 나중에 삭제
        self.createdPlaylist.append(playlist)
        
        // When: 이름이 변경된 새로운 플레이리스트 인스턴스 생성 및 업데이트
        let updatedPlaylist = playlist.copy(name: "Updated Name")
        try await self.firestoreManager.update(entity: updatedPlaylist)
        
        // Then: Firestore에서 플레이리스트를 다시 읽어옴
        let fetchedPlaylist = try await self.firestoreManager.read(entityType: MolioPlaylist.self, id: playlistID.uuidString)
        
        // Assert: 가져온 플레이리스트의 이름이 업데이트되었는지 확인
        XCTAssertNotNil(fetchedPlaylist, "가져온 플레이리스트는 nil이 아니어야 합니다")
        XCTAssertEqual(fetchedPlaylist?.name, "Updated Name", "플레이리스트의 이름이 업데이트되어야 합니다")
    }
}
