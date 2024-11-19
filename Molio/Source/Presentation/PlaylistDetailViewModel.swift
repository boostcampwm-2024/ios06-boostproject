import SwiftUI
import Combine

final class PlaylistDetailViewModel: ObservableObject {
    @Published var currentPlaylist: MolioPlaylist?
    
    private var currentPlaylistSubscription: AnyCancellable?
    
    init(
        playlistRepository: any CurrentPlaylistRepository = MockCurrentPlaylistRepository()
    ) {
        self.currentPlaylistSubscription = playlistRepository.currentPlaylistPublisher
            .sink { [weak self] playlist in
                self?.currentPlaylist = playlist
            }
    }
}


