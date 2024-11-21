import Foundation

struct DefaultChangeCurrentPlaylistUseCase: ChangeCurrentPlaylistUseCase {
    private let repository: CurrentPlaylistRepository
    
    init(
        repository: any CurrentPlaylistRepository = DIContainer.shared.resolve()
    ) {
        self.repository = repository
    }
    
    func execute(playlistId: UUID) {
        do {
            try repository.setCurrentPlaylist(playlistId)
        } catch {
            print("Failed to set current playlist: \(error)") // TODO: 현재 플레이리스트를 변경할 수 없다는 알림창 추가
        }
    }
}
