import Combine
import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    
    let fetchPlaylistUseCase: FetchPlaylistUseCase
    let currentUserIdUseCase: CurrentUserIdUseCase
    let followRelationUseCase: FollowRelationUseCase
    
    init(
         fetchPlaylistUseCase: FetchPlaylistUseCase,
        currentUserIdUseCase: CurrentUserIdUseCase,
         followRelationUseCase: FollowRelationUseCase
    ) {
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.currentUserIdUseCase = currentUserIdUseCase
        self.followRelationUseCase = followRelationUseCase
    }
    
    func fetchPlaylists(isMyProfile: Bool, friendUserID: String?) async throws {
        if isMyProfile {
            playlists = try await fetchPlaylistUseCase.fetchMyAllPlaylists()
        } else {
            guard let friendUserID else { return }
            playlists = try await fetchPlaylistUseCase.fetchFriendAllPlaylists(friendUserID: friendUserID)
        }
    }
    
    func
}
