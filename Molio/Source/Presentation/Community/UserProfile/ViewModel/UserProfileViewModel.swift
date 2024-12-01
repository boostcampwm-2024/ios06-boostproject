import Combine
import SwiftUI

final class UserProfileViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var followings: [MolioUser] = []
    @Published var followers: [MolioFollower] = []
    @Published var user: MolioUser?
    @Published var profileType: ProfileType
    @Published var isLoading: Bool = false

    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let followRelationsUseCase: FollowRelationUseCase
    private let userUseCase: UserUseCase

    init(
        profileType: ProfileType,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve(),
        followRelationsUseCase: FollowRelationUseCase = DIContainer.shared.resolve(),
        userUseCase: UserUseCase = DIContainer.shared.resolve()
    ) {
        self.profileType = profileType
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.followRelationsUseCase = followRelationsUseCase
        self.userUseCase = userUseCase
    }
    
    /// 데이터 패칭
    @MainActor
    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let (playlists, followers, followings, user) = try await fetchAllData()
            updateState(playlists: playlists, followers: followers, followings: followings, user: user)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    /// 병렬 데이터 패칭
    private func fetchAllData() async throws -> (
        playlists: [MolioPlaylist],
        followers: [MolioFollower],
        followings: [MolioUser],
        user: MolioUser?
    ) {
        async let playlists = fetchPlaylists()
        async let followers = fetchFollowers()
        async let followings = fetchFollowings()
        async let user = fetchUser()
        return try await (playlists, followers, followings, user)
    }
    
    /// 플레이리스트 가져오기
    private func fetchPlaylists() async throws -> [MolioPlaylist] {
        switch profileType {
        case .me:
            return try await fetchPlaylistUseCase.fetchMyAllPlaylists()
        case .friend(let userID, let isFollowing):
            return try await fetchPlaylistUseCase.fetchFriendAllPlaylists(friendUserID: userID)
        }
    }
    
    /// 팔로워 목록 가져오기
    private func fetchFollowers() async throws -> [MolioFollower] {
        switch profileType {
        case .me:
            return try await followRelationsUseCase.fetchMyFollowerList()
        case .friend(let userID, let isFollowing):
            return try await followRelationsUseCase.fetchFriendFollowerList(friendID: userID)
        }
    }
    
    /// 팔로잉 목록 가져오기
    private func fetchFollowings() async throws -> [MolioUser] {
        switch profileType {
        case .me:
            return try await followRelationsUseCase.fetchMyFollowingList()
        case .friend(let userID, let isFollowing):
            return try await followRelationsUseCase.fetchFriendFollowingList(friendID: userID)
        }
    }
    
    /// 사용자 정보 가져오기
    private func fetchUser() async throws -> MolioUser? {
        switch profileType {
        case .me:
            return try? await userUseCase.fetchCurrentUser()
        case .friend(let userID, let isFollowing):
            return try? await userUseCase.fetchUser(userID: userID)
        }
    }
    
    /// 상태 업데이트
    @MainActor
    private func updateState(
        playlists: [MolioPlaylist],
        followers: [MolioFollower],
        followings: [MolioUser],
        user: MolioUser?
    ) {
        self.playlists = playlists
        self.followers = followers
        self.followings = followings
        self.user = user
    }
}
