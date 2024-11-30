import SwiftUI
import Combine

final class SearchUserViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var searchedUser: [MolioUser] = MolioUser.mockArray
    
    private var allUsers: [MolioUser] = MolioUser.mockArray
    private var anyCancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] text in
                print(text)
                guard let self else { return }
                self.searchedUser = self.allUsers.filter({ $0.name.contains(text) })
            }
            .store(in: &anyCancellables)
    }
}
