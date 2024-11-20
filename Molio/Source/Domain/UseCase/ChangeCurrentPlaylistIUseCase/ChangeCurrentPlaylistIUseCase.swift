import Foundation

protocol ChangeCurrentPlaylistUseCase {
    func execute(playlistId: UUID)
}
