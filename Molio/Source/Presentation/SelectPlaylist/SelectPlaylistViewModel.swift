import Combine
import Foundation

final class SelectPlaylistViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var selectedPlaylist: MolioPlaylist?
    
    private let fetchAllPlaylistsUseCase: FetchAllPlaylistsUseCase
    private let changeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase
    private let publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchAllPlaylistsUseCase: FetchAllPlaylistsUseCase = DefaultFetchAllPlaylistsUseCase(),
        changeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase = DefaultChangeCurrentPlaylistUseCase(),
        publishCurrentPlaylistUseCase: PublishCurrentPlaylistUseCase = DIContainer.shared.resolve()
    ) {
        self.fetchAllPlaylistsUseCase = fetchAllPlaylistsUseCase
        self.changeCurrentPlaylistUseCase = changeCurrentPlaylistUseCase
        self.publishCurrentPlaylistUseCase = publishCurrentPlaylistUseCase
        
        bindPublishCurrentPlaylist()
        fetchPlaylists()
    }
    
    func fetchPlaylists() {
        Task { @MainActor [weak self] in
            guard let playlists = await self?.fetchAllPlaylistsUseCase.execute() else { return }
            self?.playlists = playlists
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
