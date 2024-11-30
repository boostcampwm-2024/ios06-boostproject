import Combine
import Foundation

final class SelectPlaylistViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var selectedPlaylist: MolioPlaylist?
    
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let changeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase
    private let publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve(),
        changeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase = DefaultChangeCurrentPlaylistUseCase(),
        publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase = DIContainer.shared.resolve()
    ) {
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.changeCurrentPlaylistUseCase = changeCurrentPlaylistUseCase
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        
        bindPublishCurrentPlaylist()
        fetchPlaylists()
    }
    
    func fetchPlaylists() {
        Task { @MainActor [weak self] in
            do {
                let playlists = try await self?.fetchPlaylistUseCase.fetchMyAllPlaylists()
                guard let playlists = playlists else { return } // TODO: - nil 처리
                self?.playlists = playlists
            } catch {
                print("플레이리스트 불러오기 실패")
            }
        }
    }
    
    func selectPlaylist(_ playlist: MolioPlaylist) {
        Task { @MainActor [weak self] in
            self?.selectedPlaylist = playlist
        }
    }
    
    func savePlaylist () {
        guard let selectedPlaylist else { return }
        changeCurrentPlaylistUseCase.execute(playlistId: selectedPlaylist.id)
    }
    
    // MARK: - Private Method
    
    private func bindPublishCurrentPlaylist() {
        publishCurrentPlaylistUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] publishedPlaylist in
                guard let self = self else { return }
                self.selectedPlaylist = publishedPlaylist
            }
            .store(in: &cancellables)
    }
}
