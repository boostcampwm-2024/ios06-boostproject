import Foundation

final class DefaultUserUseCase: UserUseCase {
    private let service: UserService
    private let currentUserIdUseCase: CurrentUserIdUseCase
    
    init(
        service: UserService = DIContainer.shared.resolve(),
        currentUserIdUseCase: CurrentUserIdUseCase = DIContainer.shared.resolve()
    ) {
        self.service = service
        self.currentUserIdUseCase = currentUserIdUseCase
    }
    
    func createUser(userName: String?) async throws {
        guard let userID = try currentUserIdUseCase.execute() else { return }
        let newUser = MolioUserDTO(
            id: userID,
            name: userName ?? "닉네임 없음",
            profileImageURL: "",
            description: ""
        )
        try await service.createUser(newUser)
    }
    
    func fetchUser(userID: String) async throws -> MolioUser {
        let userDTO = try await service.readUser(userID: userID)
        return userDTO.toEntity
    }
    
    func fetchFollower(userID: String, state: Bool) async throws -> MolioFollower {
        let userDTO = try await service.readUser(userID: userID)
        
        let profileImageURL: URL?
        if let urlString = userDTO.profileImageURL {
            profileImageURL = URL(string: urlString)
        } else {
            profileImageURL = nil
        }
        
        let user = MolioFollower(
            id: userDTO.id,
            name: userDTO.name,
            profileImageURL: profileImageURL,
            description: userDTO.description,
            state: state
        )
        return user
    }
    
    func fetchAllUsers() async throws -> [MolioUser] {
        let userDTOs = try await service.readAllUsers()
        // TODO: - MolioFollower로 교체 필요
        return userDTOs.map(\.toEntity)
    }

    func updateUser(
        userID: String,
        newName: String,
        newDescription: String?,
        imageUpdate: ProfileImageUpdateType
    ) async throws {
        // 이미지 업데이트 관련
        let updateImageURLString: String? = switch imageUpdate {
        case .keep:
            try await service.readUser(userID: userID).profileImageURL
        case .update(let imageData):
            try await service.uploadUserImage(userID: userID, data: imageData).absoluteString
        case .remove:
            ""
        }
        
        let updatedUser = MolioUserDTO(
            id: userID,
            name: newName,
            profileImageURL: updateImageURLString,
            description: newDescription
        )
        
        try await service.updateUser(updatedUser)
    }
    
    func deleteUser(userID: String) async throws {
        try await service.deleteUser(userID: userID)
    }
}
