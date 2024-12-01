import SwiftUI
import Combine

final class SearchUserViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var searchedUser: [MolioUser] = MolioUser.mockArray
    
    private var allUsers: [MolioUser] = []
    private var anyCancellables = Set<AnyCancellable>()
    
    private let currentUserIdUseCase: CurrentUserIdUseCase
    private let userUseCase: UserUseCase
    
    init(
        currentUserIdUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve(),
        userUseCase: UserUseCase = DIContainer.shared.resolve()
    ) {
        self.currentUserIdUseCase = currentUserIdUseCase
        self.userUseCase = userUseCase
        
        bind()
    }
    
    func fetchAllUsers() {
        Task {
            do {
                allUsers = try await userUseCase.fetchAllUsers()
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
                    self.filterUser($0, by: text)
                }
            }
            .store(in: &anyCancellables)
    }
    
    /// 검색 결과로 보여줄 유저를 필터링하는 메서드
    /// - 로그인하지 않은 경우 : 검색 텍스트가 포함되는 이름을 가진 유저를 모두 반환
    /// - 로그인한 경우 : 검색 텍스트가 포함되는 이름을 가지면서 현재 유저가 아닌 유저를 모두 반환
    private func filterUser(_ user: MolioUser, by searchText: String) -> Bool {
        let isContainsSearchText = user.name.contains(searchText)
        
        if let currentUserID = try? currentUserIdUseCase.execute() {
            let isOtherUser = user.id != currentUserID
            return isOtherUser && isContainsSearchText
        } else {
            return isContainsSearchText
        }
    }
}
