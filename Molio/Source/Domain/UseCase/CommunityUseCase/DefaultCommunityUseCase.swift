import Foundation

final class DefaultCommunityUseCase:
    CommunityUseCase {
    private let currentUserIdUseCase: CurrentUserIdUseCase
    private let playlistRepository: PlaylistRepository
    
    init(
        currentUserIdUseCase: CurrentUserIdUseCase,
        playlistRepository: PlaylistRepository
    ) {
        self.currentUserIdUseCase = currentUserIdUseCase
        self.playlistRepository = playlistRepository
    }
    
    func likePlaylist(playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await playlistRepository.fetchPlaylist(userID: userID, for: playlistID) else { return }
        
        var updatedLike = playlist.like
        updatedLike.append(userID)
        let newPlaylist = playlist.copy(like: updatedLike)
        try await playlistRepository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
    
    func unlikePlaylist(playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await playlistRepository.fetchPlaylist(userID: userID, for: playlistID) else { return }
        
        var updatedLike = playlist.like
        updatedLike.removeAll { $0 == userID }
        
        let newPlaylist = playlist.copy(like: updatedLike)
        try await playlistRepository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
}

enum PlaylistLikeError: Error {
    case likeNotFound
}
