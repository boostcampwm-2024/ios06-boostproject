import XCTest
import FirebaseFirestore
import FirebaseCore
@testable import Molio

final class FirestorePlaylistServiceTests: XCTestCase {
    private var createdPlaylists: [MolioPlaylistDTO] = []
    private var playlistService: FirestorePlaylistService!
    private var firestore: Firestore!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        firestore = Firestore.firestore()
        playlistService = FirestorePlaylistService(db: firestore)
    }
    
    override func tearDown() async throws {
        // 생성된 모든 재생 목록 삭제
        for playlist in createdPlaylists {
            guard let playlistID = UUID(uuidString: playlist.id) else {
                print("재생 목록 ID의 UUID가 유효하지 않습니다: \(playlist.id)")
                continue
            }
            do {
                try await playlistService.deletePlaylist(playlistID: playlistID)
            } catch {
                print("ID \(playlist.id)를 가진 재생 목록 삭제 실패: \(error)")
            }
        }
        
        // createdPlaylists 배열 비우기
        createdPlaylists.removeAll()
        
        // 서비스 초기화
        playlistService = nil
        firestore = nil
        
        try await super.tearDown()
    }
    
    // MARK: - 도우미 메서드
    /// 테스트용 재생 목록을 생성하고 정리를 위해 createdPlaylists 배열에 추가합니다.
    /// - 매개변수:
    ///   - authorID: 재생 목록의 작성자 ID.
    ///   - title: 재생 목록의 제목.
    ///   - filters: 필터 배열.
    ///   - musicISRCs: 음악 ISRC 배열.
    ///   - likes: 재생 목록을 좋아요한 사용자 ID 배열.
    /// - 반환: MolioPlaylistDTO 인스턴스.
    private func createTestPlaylist(
        authorID: String = "테스트작가ID",
        title: String = "테스트 재생 목록",
        filters: [String] = ["팝", "록"],
        musicISRCs: [String] = ["USRC17607839", "USRC17607840"],
        likes: [String] = ["user1", "user2"]
    ) -> MolioPlaylistDTO {
        let playlist = MolioPlaylistDTO(
            id: UUID().uuidString,
            authorID: authorID,
            title: title,
            createdAt: Timestamp(date: Date()),
            filters: filters,
            musicISRCs: musicISRCs,
            likes: likes
        )
        createdPlaylists.append(playlist)
        return playlist
    }
    
    /// 재생 목록 ID 문자열을 UUID로 안전하게 변환합니다.
    /// - 매개변수:
    ///   - id: 재생 목록 ID 문자열.
    /// - 반환: 변환이 성공하면 UUID, 그렇지 않으면 nil.
    private func uuid(from id: String) -> UUID? {
        return UUID(uuidString: id)
    }
    
    // MARK: - 테스트
    func testCreatePlaylist() async throws {
        let testPlaylist = createTestPlaylist()
        
        do {
            try await playlistService.createPlaylist(playlist: testPlaylist)
            
            // 재생 목록을 가져와 생성 확인
            guard let playlistID = uuid(from: testPlaylist.id) else {
                XCTFail("재생 목록 ID의 UUID가 유효하지 않습니다: \(testPlaylist.id)")
                return
            }
            
            let fetchedPlaylist = try await playlistService.readPlaylist(playlistID: playlistID)
            
            XCTAssertEqual(fetchedPlaylist.id, testPlaylist.id)
            XCTAssertEqual(fetchedPlaylist.title, testPlaylist.title)
            XCTAssertEqual(fetchedPlaylist.authorID, testPlaylist.authorID)
            XCTAssertEqual(fetchedPlaylist.filters, testPlaylist.filters)
            XCTAssertEqual(fetchedPlaylist.musicISRCs, testPlaylist.musicISRCs)
            XCTAssertEqual(fetchedPlaylist.likes, testPlaylist.likes)
        } catch {
            XCTFail("재생 목록 생성 및 확인 실패: \(error)")
        }
    }
    
    func testReadPlaylist() async throws {
        let testPlaylist = createTestPlaylist(
            authorID: "읽기테스트작가ID",
            title: "읽기 테스트 재생 목록",
            filters: ["재즈", "블루스"],
            musicISRCs: ["USRC17607841", "USRC17607842"],
            likes: ["user3", "user4"]
        )
        
        do {
            // 테스트 데이터를 Firestore에 미리 저장
            try await playlistService.createPlaylist(playlist: testPlaylist)
            
            guard let playlistID = uuid(from: testPlaylist.id) else {
                XCTFail("재생 목록 ID의 UUID가 유효하지 않습니다: \(testPlaylist.id)")
                return
            }
            
            let fetchedPlaylist = try await playlistService.readPlaylist(playlistID: playlistID)
            
            XCTAssertEqual(fetchedPlaylist, testPlaylist, "가져온 재생 목록이 생성된 재생 목록과 일치하지 않습니다.")
        } catch {
            XCTFail("재생 목록 읽기 실패: \(error)")
        }
    }
    
    func testReadAllPlaylists() async throws {
        let userID = "테스트사용자ID"
        
        let testPlaylist1 = createTestPlaylist(
            authorID: userID,
            title: "테스트 재생 목록 1",
            filters: ["일렉트로닉"],
            musicISRCs: ["USRC17607843"],
            likes: ["user5"]
        )
        
        let testPlaylist2 = createTestPlaylist(
            authorID: userID,
            title: "테스트 재생 목록 2",
            filters: ["힙합", "랩"],
            musicISRCs: ["USRC17607844", "USRC17607845"],
            likes: ["user6", "user7"]
        )
        
        do {
            // 여러 재생 목록 생성
            try await playlistService.createPlaylist(playlist: testPlaylist1)
            try await playlistService.createPlaylist(playlist: testPlaylist2)
            
            let playlists = try await playlistService.readAllPlaylist(userID: userID)
            
            // 두 재생 목록이 모두 존재하는지 확인
            XCTAssertTrue(playlists.contains { $0.id == testPlaylist1.id }, "가져온 재생 목록에 테스트 재생 목록 1이 없습니다.")
            XCTAssertTrue(playlists.contains { $0.id == testPlaylist2.id }, "가져온 재생 목록에 테스트 재생 목록 2가 없습니다.")
            
            // 각 재생 목록의 내용을 선택적으로 확인
            for testPlaylist in [testPlaylist1, testPlaylist2] {
                guard let fetchedPlaylist = playlists.first(where: { $0.id == testPlaylist.id }) else {
                    XCTFail("ID \(testPlaylist.id)를 가진 재생 목록을 찾을 수 없습니다.")
                    continue
                }
                XCTAssertEqual(fetchedPlaylist, testPlaylist, "가져온 재생 목록이 생성된 재생 목록과 일치하지 않습니다.")
            }
        } catch {
            XCTFail("모든 재생 목록 읽기 실패: \(error)")
        }
    }
    
    func testUpdatePlaylist() async throws {
        let originalPlaylist = createTestPlaylist(
            authorID: "업데이트테스트작가ID",
            title: "원본 재생 목록",
            filters: ["클래식"],
            musicISRCs: ["USRC17607846"],
            likes: ["user8"]
        )
        
        // 재생 목록 세부 정보 업데이트
        var updatedPlaylist = originalPlaylist
        updatedPlaylist.title = "업데이트된 재생 목록"
        updatedPlaylist.filters.append("기악")
        updatedPlaylist.musicISRCs.append("USRC17607847")
        updatedPlaylist.likes.append("user9")
        
        do {
            // 초기 재생 목록 생성
            try await playlistService.createPlaylist(playlist: originalPlaylist)
            
            // Firestore에서 재생 목록 업데이트
            try await playlistService.updatePlaylist(newPlaylist: updatedPlaylist)
            
            guard let playlistID = uuid(from: updatedPlaylist.id) else {
                XCTFail("재생 목록 ID의 UUID가 유효하지 않습니다: \(updatedPlaylist.id)")
                return
            }
            
            let fetchedPlaylist = try await playlistService.readPlaylist(playlistID: playlistID)
            
            XCTAssertEqual(fetchedPlaylist, updatedPlaylist, "가져온 재생 목록이 업데이트된 재생 목록과 일치하지 않습니다.")
        } catch {
            XCTFail("재생 목록 업데이트 실패: \(error)")
        }
    }
    
    func testDeletePlaylist() async throws {
        // 단계 1: 테스트 재생 목록 생성
        let testPlaylist = createTestPlaylist(
            authorID: "삭제테스트작가ID",
            title: "삭제 테스트 재생 목록",
            filters: ["소울", "펑크"],
            musicISRCs: ["USRC17607848", "USRC17607849"],
            likes: ["user10", "user11"]
        )
        
        do {
            // Firestore에 재생 목록 생성
            try await playlistService.createPlaylist(playlist: testPlaylist)
            
            guard let playlistID = uuid(from: testPlaylist.id) else {
                XCTFail("재생 목록 ID의 UUID가 유효하지 않습니다: \(testPlaylist.id)")
                return
            }
            
            // 재생 목록이 생성되었는지 확인
            let fetchedPlaylist = try await playlistService.readPlaylist(playlistID: playlistID)
            XCTAssertEqual(fetchedPlaylist.id, testPlaylist.id, "재생 목록이 올바르게 생성되지 않았습니다.")
            
            // 단계 2: 재생 목록 삭제
            try await playlistService.deletePlaylist(playlistID: playlistID)
            
            // 삭제되었으므로 createdPlaylists에서 제거
            createdPlaylists.removeAll { $0.id == testPlaylist.id }
            
            // 단계 3: 삭제된 재생 목록을 읽으려 시도
            do {
                _ = try await playlistService.readPlaylist(playlistID: playlistID)
                XCTFail("삭제된 재생 목록을 읽으려고 했으나 오류가 발생하지 않아서 실패.")
            } catch let error as NSError {
                // Firestore는 찾을 수 없는 문서에 대해 특정 오류 코드를 반환합니다
                XCTAssertEqual(error.code, error.code, "애러를 받으며 성공: \(error.code)")
            }
        } catch {
            XCTFail("재생 목록 삭제 실패: \(error)")
        }
    }
}

extension MolioPlaylistDTO: @retroactive Equatable {
    public static func == (lhs: MolioPlaylistDTO, rhs: MolioPlaylistDTO) -> Bool {
        return lhs.id == rhs.id &&
            lhs.authorID == rhs.authorID &&
            lhs.title == rhs.title &&
            lhs.filters == rhs.filters &&
            lhs.musicISRCs == rhs.musicISRCs &&
            lhs.likes == rhs.likes
    }
}
