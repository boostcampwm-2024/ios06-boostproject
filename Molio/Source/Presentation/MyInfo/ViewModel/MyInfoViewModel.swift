import Combine
import Foundation

final class MyInfoViewModel: ObservableObject {
    let nickNameCharacterLimit: Int = 10
    let descriptionCharacterLimit: Int = 50
    
    @Published var userImageURL: URL?
    @Published var userNickName: String
    @Published var userDescription: String
    
    var isPossibleNickName: Bool {
        userNickName.count <= nickNameCharacterLimit
    }
    
    var isPossibleDescription: Bool {
        userDescription.count <= descriptionCharacterLimit
    }
    
    var isPossibleConfirmButton: Bool {
        isPossibleNickName && isPossibleDescription
    }
    
    init(userNickName: String, userDescription: String) {
        self.userNickName = userNickName
        self.userDescription = userDescription
    }
}
