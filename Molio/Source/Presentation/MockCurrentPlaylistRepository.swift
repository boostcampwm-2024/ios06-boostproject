import Combine

final class MockCurrentPlaylistRepository: CurrentPlaylistRepository {
    private let playlistRepository: PlaylistRepository
    
    init(playlistRepository: PlaylistRepository = DefaultPlaylistRepository()) {
        self.playlistRepository = playlistRepository
    }
    
    var currentPlaylistPublisher: AnyPublisher<MolioPlaylist?, Never> {
        playlistRepository.playlistsPublisher
            .map { $0.first }
            .eraseToAnyPublisher()
    }
    
    var currentPlaylistFilterPublisher: AnyPublisher<[String], Never> {
        currentPlaylistPublisher
            .map { $0?.filters ?? [] }
            .eraseToAnyPublisher()
    }
    
    func setCurrentPlaylist(to playlist: MolioPlaylist) {
        
    }
    
    func setCurrentPlaylistFilter(to filter: [String]) {

    }
}
