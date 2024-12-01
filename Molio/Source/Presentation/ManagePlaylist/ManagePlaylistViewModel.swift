import Combine
import Foundation

/// CreatePlaylistView, SelectPlaylistView를 한 번에 관리하는 ViewModel
final class ManagePlaylistViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var currentPlaylist: MolioPlaylist?
    
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let managePlaylistUseCase: ManageMyPlaylistUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchPlaylistUseCase: FetchPlaylistUseCase = DefaultFetchPlaylistUseCase(
            playlistRepisitory: DefaultPlaylistRepository(
                playlistService: FirestorePlaylistService(),
                playlistStorage: CoreDataPlaylistStorage()
            ),
            musicKitService: DefaultMusicKitService(),
            currentUserIDUseCase: DefaultCurrentUserIdUseCase()
        ),
        managePlaylistUseCase: ManageMyPlaylistUseCase = DefaultManageMyPlaylistUseCase()
    ) {
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.managePlaylistUseCase = managePlaylistUseCase
        
        bindPublishCurrentPlaylist()
        fetchPlaylists()
    }
    
    /// 새로운 플레이리스트를 생성하는 함수
    func createPlaylist(playlistName: String) async throws {
        try await managePlaylistUseCase.createPlaylist(playlistName: playlistName)
    }
    
    /// 현재 플레이리스트를 불러오는 함수
    func fetchPlaylists() {
        Task { @MainActor [weak self] in
            guard let playlists = try await self?.fetchPlaylistUseCase.fetchMyAllPlaylists() else { return }
            print(playlists)
            self?.playlists = playlists
        }
    }
    
    /// 현재 플레이리스트를 선택하는 함수
    func setCurrentPlaylist(_ playlist: MolioPlaylist) {
        Task { @MainActor in
            currentPlaylist = playlist
        }
    }
    
    /// 현재플레이리스트를 저장하는 함수
    func changeCurrentPlaylist() {
        guard let currentPlaylist else { return } // TODO: 현재 선택된 알람이 없음
        managePlaylistUseCase.changeCurrentPlaylist(playlistID: currentPlaylist.id)
    }
    
    // MARK: - Private Method
    
    /// 현재 선택된 플레이리스트 바인딩하는 함수
    private func bindPublishCurrentPlaylist() {
        managePlaylistUseCase.currentPlaylistPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] publishedPlaylist in
                guard let self = self else { return }
                self.currentPlaylist = publishedPlaylist
            }
            .store(in: &cancellables)
    }
}
