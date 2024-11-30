import Combine
import Foundation
import _PhotosUI_SwiftUI

final class MyInfoViewModel: ObservableObject {
    let nickNameCharacterLimit: Int = 10
    let descriptionCharacterLimit: Int = 50
    var alertState: AlertType = .successUpdate
    
    @Published var userImageURL: URL?
    @Published var userSelectedImageData: Data?
    @Published var userNickName: String
    @Published var userDescription: String
    @Published var showAlert = false
    @Published var isLoading = false
    
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
        userNickName.count <= nickNameCharacterLimit && !userNickName.isEmpty
    }
    
    var isPossibleDescription: Bool {
        userDescription.count <= descriptionCharacterLimit
    }
    
    var isPossibleConfirmButton: Bool {
        isPossibleNickName && isPossibleDescription
    }
    
    func didSelectImage(_ item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async { [weak self] in
                guard case .success(let data) = result else { return }
                self?.userSelectedImageData = data
            }
        }
    }
    
    func updateUser() async throws {
        guard let userID = try currentUserIdUseCase.execute() else { return }
        
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            try await userUseCase.updateUser(
                userID: userID,
                newName: userNickName,
                newDescription: userDescription,
                newImageData: userSelectedImageData
            )
            await MainActor.run {
                self.alertState = .successUpdate
                self.showAlert = true
                self.isLoading = false
            }
        } catch {
            self.alertState = .failureUpdate
            self.showAlert = true
            self.isLoading = false
        }
    }
    
    enum AlertType {
        case successUpdate
        case failureUpdate
        
        var title: String {
            switch self {
            case .successUpdate:
                "내 정보가 변경되었습니다."
            case .failureUpdate:
                "내 정보 변경에 실패했습니다."
            }
        }
    }
}
