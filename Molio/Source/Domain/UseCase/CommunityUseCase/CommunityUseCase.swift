import Foundation

protocol CommunityUseCase {
    func likePlaylist(playlistID: UUID) async throws
    func unlikePlaylist(playlistID: UUID) async throws
}
