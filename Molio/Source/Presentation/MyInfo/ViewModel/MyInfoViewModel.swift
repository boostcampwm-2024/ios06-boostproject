import Combine
import Foundation

final class MyInfoViewModel: ObservableObject {
    let nickNameCharacterLimit: Int = 10
    let descriptionCharacterLimit: Int = 50
    
    @Published var userImageURL: URL?
    @Published var userNickName: String
    @Published var userDescription: String
    
    private let currentUserIdUseCase: CurrentUserIdUseCase
    private let userUseCase: UserUseCase
    
    init(
        currentUser: MolioUser,
        currentUserIdUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve(),
        userUseCase: UserUseCase = DIContainer.shared.resolve()
    ) {
        self.userImageURL = currentUser.profileImageURL
        self.userNickName = currentUser.name
        self.userDescription = currentUser.description ?? ""
        self.currentUserIdUseCase = currentUserIdUseCase
        self.userUseCase = userUseCase
    }
    
    var isPossibleNickName: Bool {
        userNickName.count <= nickNameCharacterLimit
    }
    
    var isPossibleDescription: Bool {
        userDescription.count <= descriptionCharacterLimit
    }
    
    var isPossibleConfirmButton: Bool {
        isPossibleNickName && isPossibleDescription
    }
}
