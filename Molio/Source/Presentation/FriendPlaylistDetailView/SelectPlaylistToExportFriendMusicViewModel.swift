import Combine
import Foundation
import SwiftUI

final class SelectPlaylistToExportFriendMusicViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var selectedPlaylist: MolioPlaylist?
    
    private let fetchAllPlaylistsUseCase: FetchAllPlaylistsUseCase
    
    private let manageMyPlaylistUseCase: ManageMyPlaylistUseCase
    
    let selectedMusic: MolioMusic
    
    init(
        fetchAllPlaylistsUseCase: FetchAllPlaylistsUseCase = DefaultFetchAllPlaylistsUseCase(),
        manageMyPlaylistUseCase: ManageMyPlaylistUseCase = DefaultManageMyPlaylistUseCase(),
        
        selectedMusic: MolioMusic
    ) {
        self.fetchAllPlaylistsUseCase = fetchAllPlaylistsUseCase
        self.manageMyPlaylistUseCase = manageMyPlaylistUseCase
        self.selectedMusic = selectedMusic
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
    
    func exportMusicToMyPlaylist (music: MolioMusic) {
        guard let selectedPlaylist else { return }
        
        Task {
            do {
                try await manageMyPlaylistUseCase.addMusic(musicISRC: music.isrc, to: selectedPlaylist.id)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
