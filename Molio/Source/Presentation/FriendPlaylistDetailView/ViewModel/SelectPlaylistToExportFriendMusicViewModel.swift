import Combine
import SwiftUI

final class SelectPlaylistToExportFriendMusicViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var selectedPlaylist: MolioPlaylist?
    
    let selectedMusic: MolioMusic

    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let manageMyPlaylistUseCase: ManageMyPlaylistUseCase
    
    init(
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve(),
        manageMyPlaylistUseCase: ManageMyPlaylistUseCase = DIContainer.shared.resolve(),
        
        selectedMusic: MolioMusic
    ) {
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.manageMyPlaylistUseCase = manageMyPlaylistUseCase
        self.selectedMusic = selectedMusic
        fetchPlaylists()
    }
    
    func fetchPlaylists() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                self.playlists = try await self.fetchPlaylistUseCase.fetchMyAllPlaylists()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func selectPlaylist(_ playlist: MolioPlaylist) {
        Task { @MainActor [weak self] in
            self?.selectedPlaylist = playlist
        }
    }
    
    func exportMusicToMyPlaylist (music: MolioMusic) {
        guard let selectedPlaylist else { return }
        
        Task {
            do {
                try await manageMyPlaylistUseCase
                    .addMusic(
                        musicISRC: music.isrc,
                        to: selectedPlaylist.id
                    )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
