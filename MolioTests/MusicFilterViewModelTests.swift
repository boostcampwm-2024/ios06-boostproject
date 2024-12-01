import Combine
import XCTest
@testable import Molio

final class MusicFilterViewModelTests: XCTestCase {
    private var sut: MusicFilterViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        sut = MusicFilterViewModel(
            fetchAvailableGenresUseCase: MockFetchAvailableGenresUseCase(),
            managePlaylistUseCase: MockManagePlaylistUseCase()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_현재플레이리스트가_있을때_정보를_받아오면_현재_플레이리스트_정보가_갱신된다() {
        // Given
        let mockUUID = UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!
        let mockFilter = MusicFilter(genres: [.pop, .acoustic])
        let mockPlaylist = MolioPlaylist(
            id: mockUUID,
            name: "",
            createdAt: Date(),
            musicISRCs: [],
            filter: mockFilter
        )
        let mockManagePlaylistUseCase = MockManagePlaylistUseCase(playlistToReturn: mockPlaylist)
        sut = MusicFilterViewModel(
            fetchAvailableGenresUseCase: MockFetchAvailableGenresUseCase(),
            managePlaylistUseCase: mockManagePlaylistUseCase
        )
        var result: UUID!
        
        // When
        mockManagePlaylistUseCase.currentPlaylistPublisher()
            .sink { playlist in
                result = playlist?.id
            }
            .store(in: &subscriptions)
        
        
        // Then
        XCTAssertEqual(result, mockUUID)
    }
    
    func test_현재플레이리스트가_있을때_정보를_받아오면_현재_플레이리스트_필터의_선택된_장르_정보로_갱신된다() {
        // Given
        let mockUUID = UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!
        let mockFilter = MusicFilter(genres: [.pop, .acoustic])
        let mockPlaylist = MolioPlaylist(
            id: mockUUID,
            name: "",
            createdAt: Date(),
            musicISRCs: [],
            filter: mockFilter
        )
        let mockManagePlaylistUseCase = MockManagePlaylistUseCase(playlistToReturn: mockPlaylist)
        sut = MusicFilterViewModel(
            fetchAvailableGenresUseCase: MockFetchAvailableGenresUseCase(),
            managePlaylistUseCase: mockManagePlaylistUseCase
        )
        var result: MolioPlaylist!
        
        // When
        mockManagePlaylistUseCase.currentPlaylistPublisher()
            .sink { playlist in
                result = playlist
            }
            .store(in: &subscriptions)
        
        
        // Then
        XCTAssertEqual(result.filter.genres, mockFilter.genres)
    }
}
