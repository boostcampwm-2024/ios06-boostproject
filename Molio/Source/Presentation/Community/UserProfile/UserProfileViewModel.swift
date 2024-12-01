import Combine
import SwiftUI

final class UserProfileViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var followings: [MolioUser] = []
    @Published var followers: [MolioFollower] = []
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
    
    /// 메인 데이터 가져오기
    @MainActor
    func fetchData(isMyProfile: Bool, friendUserID: String?) async {
        updateLoadingState(true)
        defer { updateLoadingState(false) }

        do {
            let (playlists, followers, followings, user) = try await fetchAllData(
                isMyProfile: isMyProfile,
                friendUserID: friendUserID
            )
            print(user ?? "", playlists, followings, followers)
            await updateState(playlists: playlists, followers: followers, followings: followings, user: user)
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    /// 데이터 병렬 처리 및 반환
    private func fetchAllData(isMyProfile: Bool, friendUserID: String?) async throws -> (
        playlists: [MolioPlaylist],
        followers: [MolioFollower],
        followings: [MolioUser],
        user: MolioUser?
    ) {
        async let playlists = fetchPlaylists(isMyProfile: isMyProfile, friendUserID: friendUserID)
        async let followers = fetchFollowers(isMyProfile: isMyProfile, friendUserID: friendUserID)
        async let followings = fetchFollowings(isMyProfile: isMyProfile, friendUserID: friendUserID)
        async let user = fetchUser(isMyProfile: isMyProfile, friendUserID: friendUserID)
        return try await (playlists, followers, followings, user)
    }
    
    /// 플레이리스트 가져오기
    private func fetchPlaylists(isMyProfile: Bool, friendUserID: String?) async throws -> [MolioPlaylist] {
        if isMyProfile {
            return try await fetchPlaylistUseCase.fetchMyAllPlaylists()
        } else if let friendUserID = friendUserID {
            return try await fetchPlaylistUseCase.fetchFriendAllPlaylists(friendUserID: friendUserID)
        }
        return []
    }
    
    /// 팔로워 목록 가져오기
    private func fetchFollowers(isMyProfile: Bool, friendUserID: String?) async throws -> [MolioFollower] {
        if isMyProfile {
            return try await followRelationUseCase.fetchMyFollowerList()
        } else if let friendUserID = friendUserID {
            return try await followRelationUseCase.fetchFriendFollowerList(friendID: friendUserID)
        }
        return []
    }
    
    /// 팔로잉 목록 가져오기
    private func fetchFollowings(isMyProfile: Bool, friendUserID: String?) async throws -> [MolioUser] {
        if isMyProfile {
            return try await followRelationUseCase.fetchMyFollowingList()
        } else if let friendUserID = friendUserID {
            return try await followRelationUseCase.fetchFriendFollowingList(friendID: friendUserID)
        }
        return []
    }
    
    /// 사용자 정보 가져오기
    private func fetchUser(isMyProfile: Bool, friendUserID: String?) async throws -> MolioUser? {
        if isMyProfile {
            if let userID = try currentUserIdUseCase.execute() {
                return try await userUseCase.fetchUser(userID: userID)
            }
        } else if let friendUserID = friendUserID {
            return try await userUseCase.fetchUser(userID: friendUserID)
        }
        return nil
    }
    
    /// 상태 업데이트 (메인 스레드)
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
    
    /// 로딩 상태 업데이트 (메인 스레드)
    @MainActor
    private func updateLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}
