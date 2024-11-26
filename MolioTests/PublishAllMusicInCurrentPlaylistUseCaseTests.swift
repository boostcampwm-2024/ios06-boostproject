import XCTest
@testable import Molio
import Combine

final class PublishAllMusicInCurrentPlaylistUseCaseTests: XCTestCase {
    private let examplePlaylist = MolioPlaylist(
        id: UUID(),
        name: "My Favorite Songs",
        createdAt: Date(),
        musicISRCs: ["USUM72014967", "USUM72014968"],
        filter: MusicFilter(genres: [.pop, .metal])
    )
    private let newPlaylist = MolioPlaylist(
        id: UUID(),
        name: "Chill Vibes",
        createdAt: Date(),
        musicISRCs: ["USUM72014969", "USUM72014970"],
        filter: MusicFilter(genres: [.chill, .acoustic])
    )

    private var subscriptions = Set<AnyCancellable>()
    
    func testPlaylistMusicsWhenPlaylistChanged() {
        let mockPublishCurrentPlaylistUseCase = MockPublishCurrentPlaylistUseCase()
        
        let _ = DefaultPublishAllMusicInCurrentPlaylistUseCase(publishCurrentPlaylistUseCase: mockPublishCurrentPlaylistUseCase, musicKitService: DefaultMusicKitService())
        
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
