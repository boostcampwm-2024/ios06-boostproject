import Foundation

protocol CreatePlaylistUseCase {
    func execute(playlistName: String) async -> UUID?
}
