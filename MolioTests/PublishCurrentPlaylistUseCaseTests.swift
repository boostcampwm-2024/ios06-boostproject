import XCTest
@testable import Molio
import Combine

final class PublishCurrentPlaylistUseCaseTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    // `CurrentPlaylistRepository`에서 플레이리스트의 UUID가 변경될 때,
    // `DefaultPublishCurrentPlaylistUseCase`가 제공하는 퍼블리셔가
    // 올바르게 업데이트된 플레이리스트를 방출하는지 검증하는 테스트입니다.
    func testChangePlaylistUUID() {
        let mockCurrentPlaylistRepository = MockCurrentPlaylistRepository()
        let mockPlaylistRepository = MockPlaylistRepository()
        
        let useCase = DefaultPublishCurrentPlaylistUseCase(
            playlistRepository: mockPlaylistRepository,
            currentPlaylistRepository: mockCurrentPlaylistRepository
        )
        
        let expectation1 = expectation(description: "First playlist emitted")
        let expectation2 = expectation(description: "Second playlist emitted")
        let expectation3 = expectation(description: "Third playlist emitted")
        
        var emittedPlaylists: [MolioPlaylist?] = []
        
        useCase.execute()
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink { playlist in
                emittedPlaylists.append(playlist)
                
                // Fulfill expectations based on the number of emitted playlists
                switch emittedPlaylists.count {
                case 1:
                    expectation1.fulfill()
                case 2:
                    expectation2.fulfill()
                case 3:
                    expectation3.fulfill()
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        // Trigger playlist UUID changes
        mockCurrentPlaylistRepository.setCurrentPlaylist(UUID())
        mockCurrentPlaylistRepository.setCurrentPlaylist(UUID())
        
        // Wait for all expectations to be fulfilled within a timeout
        wait(for: [expectation1, expectation2, expectation3], timeout: 2.0)
        
        // Now perform your assertions
        if emittedPlaylists.count >= 3 {
            XCTAssertNotEqual(emittedPlaylists[0]?.name, emittedPlaylists[1]?.name, "First and second playlists should have different names.")
            XCTAssertNotEqual(emittedPlaylists[1]?.name, emittedPlaylists[2]?.name, "Second and third playlists should have different names.")
        } else {
            XCTFail("플레이리스트가 변경되지 않았습니다.")
        }
    }
}
