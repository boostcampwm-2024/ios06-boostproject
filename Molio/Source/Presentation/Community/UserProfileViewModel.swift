import Combine
import SwiftUI

class UserProfileViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var followings: [MolioFollowRelation] = []
    @Published var followers: [MolioFollowRelation] = []
    @Published var user: MolioUser?
    @Published var isLoading: Bool = false
    @Published var currentID: String?
    
    let fetchPlaylistUseCase: FetchPlaylistUseCase
    let currentUserIdUseCase: CurrentUserIdUseCase
    let followRelationUseCase: FollowRelationUseCase
    let userUseCase: UserUseCase

    init(
        fetchPlaylistUseCase: FetchPlaylistUseCase,
        currentUserIdUseCase: CurrentUserIdUseCase,
        followRelationUseCase: FollowRelationUseCase,
        userUseCase: UserUseCase
    ) {
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.currentUserIdUseCase = currentUserIdUseCase
        self.followRelationUseCase = followRelationUseCase
        self.userUseCase = userUseCase
    }
    
    func fetchData(isMyProfile: Bool, friendUserID: String?) async throws {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
        
        guard let currentID = try currentUserIdUseCase.execute() else {
            let fetchedPlaylists = try await fetchPlaylists(isMyProfile: isMyProfile, friendUserID: friendUserID)
            DispatchQueue.main.async {
                self.playlists = fetchedPlaylists
            }
            return
        }
        
        let fetchedPlaylists = try await fetchPlaylists(isMyProfile: isMyProfile, friendUserID: friendUserID)
        let fetchedFollowers = try await fetchFollowers(isMyProfile: isMyProfile, friendUserID: friendUserID)
        let fetchedFollowings = try await fetchFollowings(isMyProfile: isMyProfile, friendUserID: friendUserID)
        
        guard let friendUserID else { return }
        let fetchedUser = try await userUseCase.fetchUser(userID: isMyProfile ? currentID : friendUserID)
        
        DispatchQueue.main.async {
            self.playlists = fetchedPlaylists
            self.followers = fetchedFollowers
            self.followings = fetchedFollowings
            self.user = fetchedUser
        }
    }
    
    private func fetchPlaylists(isMyProfile: Bool, friendUserID: String?) async throws -> [MolioPlaylist] {
        if isMyProfile {
            return try await fetchPlaylistUseCase.fetchMyAllPlaylists()
        } else {
            guard let friendUserID else { return [] }
            return try await fetchPlaylistUseCase.fetchFriendAllPlaylists(friendUserID: friendUserID)
        }
    }
    
    private func fetchFollowers(isMyProfile: Bool, friendUserID: String?) async throws -> [MolioFollowRelation] {
        if isMyProfile {
            return try await followRelationUseCase.fetchMyFollowerList()
        } else {
            guard let friendUserID else { return [] }
            return try await followRelationUseCase.fetchFriendFollowerList(userID: friendUserID)
        }
    }
    
    private func fetchFollowings(isMyProfile: Bool, friendUserID: String?) async throws -> [MolioFollowRelation] {
        if isMyProfile {
            return try await followRelationUseCase.fetchMyFollowingList()
        } else {
            guard let friendUserID else { return [] }
            return try await followRelationUseCase.fetchFreindFollowingList(userID: friendUserID)
        }
    }
}
