import XCTest
@testable import Molio
import Combine

final class PublishAllPlaylistTitleUseCaseTests: XCTestCase {
    
    func testAddNewPlaylistAndSeeIfItIsPublished() async throws {
        var subscriptions = Set<AnyCancellable>()

        // 레포지토리에 플레이리스트를 만들고 expectation 다음게 하나가 추가 되었는지 맞는지 확인
        let mockPlaylistRepository = MockPlaylistRepository()
        
        let useCase = DefaultPublishAllPlaylistTitleUseCase(
            playlistRepository: mockPlaylistRepository
        )
        
        let expectation1 = expectation(description: "Initial empty playlist emitted")
        let expectation2 = expectation(description: "New playlist title emitted")
        
        var emittedPlaylistTitles: [[String]] = []
        
        useCase.execute()
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .sink { titles in
                emittedPlaylistTitles.append(titles)
                
                // Fulfill expectations based on the number of emitted titles
                switch emittedPlaylistTitles.count {
                case 1:
                    expectation1.fulfill()
                case 2:
                    expectation2.fulfill()
                default:
                    break
                }
            }
            .store(in: &subscriptions)
        
        // Initially, the repository has no playlists
        // Fulfill the first expectation
        // (Already handled by the publisher emitting the initial state)
        
        // Add a new playlist
        let newPlaylistName = "My New Playlist"
        
        Task {
            let _ = try await mockPlaylistRepository.saveNewPlaylist(newPlaylistName)

            let _ = try await mockPlaylistRepository.saveNewPlaylist(newPlaylistName)

        }

        // Wait for all expectations to be fulfilled within a timeout
        wait(for: [expectation1, expectation2], timeout: 2.0)
        
        print(emittedPlaylistTitles)
        
        // Now perform your assertions
        XCTAssertEqual(emittedPlaylistTitles.count, 3, "Should emit initial and updated playlist titles.")
        
        // Initial emission should be empty
        XCTAssertEqual(emittedPlaylistTitles[0], [], "Initial playlist titles should be empty.")
        
        // After adding, the second emission should contain the new playlist
        XCTAssertEqual(emittedPlaylistTitles[1], [newPlaylistName], "Playlist titles should include the new playlist.")
        
        XCTAssertEqual(emittedPlaylistTitles[2], [newPlaylistName, newPlaylistName], "Playlist titles should include the new playlist.")

    }
}


private final class MockPlaylistRepository: PlaylistRepository {
    
    // CurrentValueSubject to hold the current state of playlists
    private var playlistsSubject: CurrentValueSubject<[MolioPlaylist], Never>
    
    // Public publisher as required by the protocol
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> {
        playlistsSubject.eraseToAnyPublisher()
    }
    
    // Internal storage for playlists
    private var playlists: [MolioPlaylist]
    
    init(initialPlaylists: [MolioPlaylist] = []) {
        self.playlists = initialPlaylists
        self.playlistsSubject = CurrentValueSubject(initialPlaylists)
    }
    
    // Adds a new playlist and publishes the updated list
    func saveNewPlaylist(_ playlistName: String) async throws -> UUID {
        let newPlaylist = MolioPlaylist(id: UUID(), name: playlistName, createdAt: .now, musicISRCs: [], filters: [])
        playlists.append(newPlaylist)
        playlistsSubject.send(playlists)
        return newPlaylist.id
    }
    
    // Deletes a playlist by name and publishes the updated list
    func deletePlaylist(_ playlistName: String) {
        playlists.removeAll { $0.name == playlistName }
        playlistsSubject.send(playlists)
    }
    
    // Fetches all playlists
    func fetchPlaylists() -> [MolioPlaylist]? {
        return playlists
    }
    
    // Fetches a specific playlist by name
    func fetchPlaylist(for name: String) async throws -> MolioPlaylist? {
        return playlists.first { $0.name == name }
    }
    
    // Adds music to a playlist
    func addMusic(isrc: String, to playlistName: String) {
    }
    
    // Deletes music from a playlist
    func deleteMusic(isrc: String, in playlistName: String) {
    }
    
    // Moves music within a playlist
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {
        
    }
}
