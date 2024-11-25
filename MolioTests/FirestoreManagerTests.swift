import XCTest
@testable import Molio

final class FirestoreManagerTests: XCTestCase {
    var firestoreManager: FirestoreManager!
    
    override func setUp() {
        super.setUp()
        
        self.firestoreManager = FirestoreManager()
    }
    
    override func tearDown() {
        self.firestoreManager = nil
        
        super.tearDown()
    }
    
    func testCreatePlaylist() async throws {
        let playlist = MolioPlaylist(id: UUID(), name: "test", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        
        try await self.firestoreManager.create(entity: playlist)
        
        XCTAssertNotNil(playlist)
    }
    
    func testReadPlaylist() async throws {
        // Given: 새로운 플레이리스트 생성
        let playlistID = UUID()
        
        let playlist = MolioPlaylist(id: playlistID, name: "Test Playlist", createdAt: .now, musicISRCs: [], filter: MusicFilter(genres: []))
        
        // When: 플레이리스트를 Firestore에 저장
        try await self.firestoreManager.create(entity: playlist)
        
        // Then: Firestore에서 플레이리스트를 다시 읽어옴
        let fetchedPlaylist = try await self.firestoreManager.read(entityType: MolioPlaylist.self, id: playlistID.uuidString)
        
        // Assert: 가져온 플레이리스트가 nil이 아니고 원본과 일치하는지 확인
        XCTAssertNotNil(fetchedPlaylist, "가져온 플레이리스트는 nil이 아니어야 합니다")
        XCTAssertEqual(fetchedPlaylist?.id, playlist.id, "가져온 플레이리스트의 ID는 원본과 일치해야 합니다")
        XCTAssertEqual(fetchedPlaylist?.name, playlist.name, "가져온 플레이리스트의 이름은 원본과 일치해야 합니다")
        XCTAssertEqual(fetchedPlaylist?.createdAt.timeIntervalSince1970 ?? 0, playlist.createdAt.timeIntervalSince1970, accuracy: TimeInterval(1), "가져온 플레이리스트의 생성 날짜는 원본과 일치해야 합니다")
    }}
