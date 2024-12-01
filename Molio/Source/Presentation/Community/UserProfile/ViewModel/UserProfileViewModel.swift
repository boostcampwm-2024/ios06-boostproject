import Combine
import SwiftUI

final class UserProfileViewModel: ObservableObject {
    @Published var playlists: [MolioPlaylist] = []
    @Published var followings: [MolioFollower] = []
    @Published var followers: [MolioFollower] = []
    @Published var user: MolioFollower?
    @Published var profileType: ProfileType
    @Published var isLoading: Bool = false

    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    private let followRelationUseCase: FollowRelationUseCase
    private let userUseCase: UserUseCase

    init(
        profileType: ProfileType,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve(),
        followRelationUseCase: FollowRelationUseCase = DIContainer.shared.resolve(),
        userUseCase: UserUseCase = DIContainer.shared.resolve()
    ) {
        self.profileType = profileType
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.followRelationUseCase = followRelationUseCase
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
        followings: [MolioFollower],
        user: MolioFollower?
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
        case .friend(let userID, _):
            return try await fetchPlaylistUseCase.fetchFriendAllPlaylists(friendUserID: userID)
        }
    }
    
    /// 팔로워 목록 가져오기
    private func fetchFollowers() async throws -> [MolioFollower] {
        switch profileType {
        case .me:
            return try await followRelationUseCase.fetchMyFollowerList()
        case .friend(let userID, _):
            return try await followRelationUseCase.fetchFriendFollowerList(friendID: userID)
        }
    }
    
    /// 팔로잉 목록 가져오기
    private func fetchFollowings() async throws -> [MolioFollower] {
        switch profileType {
        case .me:
            return try await followRelationUseCase.fetchMyFollowingList()
        case .friend(let userID, _):
            return try await followRelationUseCase.fetchFriendFollowingList(friendID: userID)
        }
    }
    
    /// 사용자 정보 가져오기
    private func fetchUser() async throws -> MolioFollower? {
        switch profileType {
        case .me:
            let user = try? await userUseCase.fetchCurrentUser()
            return user?.convertToFollower(followRelation: .following)
        case .friend(let userID, _):
            return try? await followRelationUseCase.fetchFollower(userID: userID)
        }
    }
    
    /// 상태 업데이트
    @MainActor
    private func updateState(
        playlists: [MolioPlaylist],
        followers: [MolioFollower],
        followings: [MolioFollower],
        user: MolioFollower?
    ) {
        self.playlists = playlists
        self.followers = followers
        self.followings = followings
        self.user = user
    }
    
    /// 팔로우 상태 업데이트 메서드
    @MainActor
    func updateFollowState(to type: FollowRelationType) async {
        guard let user else { return }
        do {
            // 서버에 팔로우 상태 업데이트
            switch type {
            case .following:
                try await followRelationUseCase.unFollow(to: user.id)
            case .unfollowing:
                try await followRelationUseCase.requestFollowing(to: user.id)
            }

            await fetchData()
        } catch {
            print("Failed to update follow state: \(error.localizedDescription)")
        }
    }
}
