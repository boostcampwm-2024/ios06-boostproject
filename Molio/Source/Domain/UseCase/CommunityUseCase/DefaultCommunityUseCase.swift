import Foundation

final class DefaultCommunityUseCase:
    CommunityUseCase {
    private let currentUserIdUseCase: CurrentUserIdUseCase
    private let repository: RealPlaylistRepository
    
    init(
        currentUserIdUseCase: CurrentUserIdUseCase,
        repository: RealPlaylistRepository
    ) {
        self.currentUserIdUseCase = currentUserIdUseCase
        self.repository = repository
    }
    
    func likePlaylist(playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await repository.fetchPlaylist(userID: userID, for: playlistID) else { return }
        
        guard var updatedLike = playlist.like else { throw PlaylistLikeError.likeNotFound }
        
        updatedLike.append(userID)
        let newPlaylist = playlist.copy(like: updatedLike)
        try await repository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
    
    func unlikePlaylist(playlistID: UUID) async throws {
        guard let userID = try currentUserIdUseCase.execute(),
              let playlist = try await repository.fetchPlaylist(userID: userID, for: playlistID) else { return }
        
        guard var updatedLike = playlist.like else { throw PlaylistLikeError.likeNotFound }
        
        updatedLike.removeAll { $0 == userID }
        
        let newPlaylist = playlist.copy(like: updatedLike)
        try await repository.updatePlaylist(userID: userID, newPlaylist: newPlaylist)
    }
}

enum PlaylistLikeError: Error {
    case likeNotFound
}
