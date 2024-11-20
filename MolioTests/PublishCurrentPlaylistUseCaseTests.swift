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
        
        var playlists: [MolioPlaylist?] = []
        
        let currentPlaylistPublisher = useCase.execute()
        
        currentPlaylistPublisher
            .sink { playlist in
                playlists.append(playlist)
            }
        
        .store(in: &subscriptions)

        mockCurrentPlaylistRepository.setCurrentPlaylist(UUID())
        
        mockCurrentPlaylistRepository.setCurrentPlaylist(UUID())
        
        if playlists.count >= 3 {
            XCTAssertNotEqual(playlists[0]?.name, playlists[1]?.name)
            XCTAssertNotEqual(playlists[1]?.name, playlists[2]?.name)
        } else {
            XCTFail("플레이리스트가 변경되지 않았습니다.")
        }
    }
}


private class MockCurrentPlaylistRepository: CurrentPlaylistRepository {
    func setDefaultPlaylist(_ id: UUID) throws {
        
    }
    
    private var currentPlaylistUUID = CurrentValueSubject<UUID?, Never>(nil)
    
    var currentPlaylistPublisher: AnyPublisher<UUID?, Never> {
        currentPlaylistUUID.eraseToAnyPublisher()
    }
    
    func setCurrentPlaylist(_ id: UUID) {
        currentPlaylistUUID.send(id)
    }
}

private class MockPlaylistRepository: PlaylistRepository {
    private var playlists = CurrentValueSubject<[MolioPlaylist], Never>([])
    
    var playlistsPublisher: AnyPublisher<[MolioPlaylist], Never> {
        playlists.eraseToAnyPublisher()
    }
    
    func addMusic(isrc: String, to playlistName: String) {
    }
    
    func deleteMusic(isrc: String, in playlistName: String) {

    }
    
    func deletePlaylist(_ playlistName: String) {
        
    }
    
    func fetchPlaylist(for name: String) -> MolioPlaylist? {
        MolioPlaylist(id: UUID(), name: name, createdAt: Date.now, musicISRCs: [], filters: [])
    }
    
    func fetchPlaylists() -> [MolioPlaylist]? {
        []
    }
    
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {
        
    }
    
    func saveNewPlaylist(_ playlistName: String) {
        
    }
}
