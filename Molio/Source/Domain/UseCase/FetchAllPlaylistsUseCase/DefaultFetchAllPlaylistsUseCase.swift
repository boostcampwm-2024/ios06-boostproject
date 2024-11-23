import Foundation

final class DefaultFetchAllPlaylistsUseCase: FetchAllPlaylistsUseCase {
    private let playlistRepository: any PlaylistRepository

    init(
        playlistRepository: any PlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.playlistRepository = playlistRepository
    }
    
    func execute() async -> [MolioPlaylist] {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                let playlists = self.playlistRepository.fetchPlaylists() ?? []
                continuation.resume(returning: playlists)
            }
        }
    }
}
