import XCTest
@testable import Molio
import Combine

final class PublishAllMusicInCurrentPlaylistUseCaseTests: XCTestCase {
    private let examplePlaylist = MolioPlaylist(
        id: UUID(),
        name: "My Favorite Songs",
        createdAt: Date(),
        musicISRCs: ["USUM72014967", "USUM72014968"],
        filters: ["Pop", "2020s"]
    )
    private let newPlaylist = MolioPlaylist(
        id: UUID(),
        name: "Chill Vibes",
        createdAt: Date(),
        musicISRCs: ["USUM72014969", "USUM72014970"],
        filters: ["Chill", "Acoustic"]
    )

    private var subscriptions = Set<AnyCancellable>()
    
    func testPlaylistMusicsWhenPlaylistChanged() {
        let mockPublishCurrentPlaylistUseCase = MockPublishCurrentPlaylistUseCase()
        
        let useCase = DefaultPublishAllMusicInCurrentPlaylistUseCase(publishCurrentPlaylistUseCase: mockPublishCurrentPlaylistUseCase, musicKitService: DefaultMusicKitService())
        
        let expectation1 = expectation(description: "First playlist emitted")
        let expectation2 = expectation(description: "Second playlist emitted")

        var emittedMusicISRCs: [[String]] = []
        
        mockPublishCurrentPlaylistUseCase
            .execute()
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink { playlist in
                emittedMusicISRCs.append(playlist?.musicISRCs ?? [])
                
                switch emittedMusicISRCs.count {
                case 1:
                    expectation1.fulfill()
                case 2:
                    expectation2.fulfill()
                default:
                    break
                }
                // Fulfill expectations based on the number of emitted playlists
            }
            .store(in: &subscriptions)
        mockPublishCurrentPlaylistUseCase.updatePlaylist(examplePlaylist)
        mockPublishCurrentPlaylistUseCase.updatePlaylist(newPlaylist)
        // Wait for all expectations to be fulfilled within a timeout
        wait(for: [expectation1, expectation2], timeout: 2.0)
        
        print(emittedMusicISRCs)
        
        // Now perform your assertions
        XCTAssertNotEqual(emittedMusicISRCs[0], emittedMusicISRCs[1], "First and second playlists should have different music ISRCs.")
    }
}


// Mock 구현을 위한 클래스
private class MockPublishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase {
    
    // 원하는 MolioPlaylist을 설정할 수 있는 프로퍼티
    var mockPlaylist: MolioPlaylist?
    
    // 데이터를 발행하기 위한 퍼블리셔
    private var subject: CurrentValueSubject<MolioPlaylist?, Never>
    
    // 초기화 시 mockPlaylist를 설정하고 subject를 초기화
    init(mockPlaylist: MolioPlaylist? = nil) {
        self.mockPlaylist = mockPlaylist
        self.subject = CurrentValueSubject<MolioPlaylist?, Never>(mockPlaylist)
    }
    
    // 프로토콜의 execute 메서드 구현
    func execute() -> AnyPublisher<MolioPlaylist?, Never> {
        return subject.eraseToAnyPublisher()
    }
    
    // 테스트 중에 mockPlaylist를 업데이트할 수 있는 메서드
    func updatePlaylist(_ playlist: MolioPlaylist?) {
        self.mockPlaylist = playlist
        subject.send(playlist)
    }
}
