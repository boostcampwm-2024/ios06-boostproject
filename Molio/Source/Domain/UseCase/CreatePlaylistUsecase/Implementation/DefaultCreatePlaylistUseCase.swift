import Foundation

struct DefaultCreatePlaylistUseCase: CreatePlaylistUseCase {
    private let playlistRepository: PlaylistRepository
    
    init(repository: PlaylistRepository) {
        self.playlistRepository = repository
    }
    
    func execute(playlistName: String) async -> UUID? {
        do {
            return try await playlistRepository.saveNewPlaylist(playlistName)
        } catch {
            print("Failed to save playlist '\(playlistName)': \(error.localizedDescription)") // TODO: 현재 플리를 다시 저장해달라는 알림창 추가
            return nil
        }
    }
}
