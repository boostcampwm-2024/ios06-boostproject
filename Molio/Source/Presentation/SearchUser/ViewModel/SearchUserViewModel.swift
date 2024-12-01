import Combine
import SwiftUI

final class SearchUserViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var searchedUser: [MolioFollower] = []
    
    private var allUsers: [MolioFollower] = []
    private var anyCancellables = Set<AnyCancellable>()
    
    private let currentUserIdUseCase: CurrentUserIdUseCase
    private let followRelationUseCase: FollowRelationUseCase
    
    init(
        currentUserIdUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve(),
        followRelationUseCase: FollowRelationUseCase = DIContainer.shared.resolve()
    ) {
        self.currentUserIdUseCase = currentUserIdUseCase
        self.followRelationUseCase = followRelationUseCase
        
        bind()
    }
    
    @MainActor
    func fetchAllUsers() {
        Task {
            do {
                allUsers = try await followRelationUseCase.fetchAllFollowers()
            } catch {
                print("검색 유저들을 불러오지 못함.")
            }
        }
    }
    
    // MARK: - Private methods
    
    private func bind() {
        $searchText
            .sink { [weak self] text in
                guard let self else { return }
                self.searchedUser = self.allUsers.filter {
                    self.filteredBySearchText($0, by: text)
                }
            }
            .store(in: &anyCancellables)
    }
    
    /// 검색 결과로 보여줄 유저를 필터링
    /// - 로그인하지 않은 경우 : 검색 텍스트가 포함되는 이름을 가진 유저를 모두 반환
    /// - 로그인한 경우 : 검색 텍스트가 포함되는 이름을 가지면서 현재 유저가 아닌 유저를 모두 반환
    private func filteredBySearchText(_ user: MolioFollower, by searchText: String) -> Bool {
        let isContainsSearchText = user.name.contains(searchText)
        
        if let currentUserID = try? currentUserIdUseCase.execute() {
            let isOtherUser = user.id != currentUserID
            return isOtherUser && isContainsSearchText
        } else {
            return isContainsSearchText
        }
    }
    
    /// 팔로우 상태 업데이트 메서드
    @MainActor
    func updateFollowState(for user: MolioFollower, to type: FollowRelationType) async {
        do {
            // 서버에 팔로우 상태 업데이트
            switch type {
            case .following:
                try await followRelationUseCase.unFollow(to: user.id)
            case .unfollowing:
                try await followRelationUseCase.requestFollowing(to: user.id)
            }

            await reloadUsers()
        } catch {
            print("Failed to update follow state: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func reloadUsers() async {
        do {
            let updatedUsers = try await followRelationUseCase.fetchAllFollowers()
            allUsers = updatedUsers
            searchedUser = allUsers.filter { filteredBySearchText($0, by: searchText) }
        } catch {
            print("Failed to reload users: \(error.localizedDescription)")
        }
    }
}
