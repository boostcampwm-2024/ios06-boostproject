import Foundation

final class DefaultUserUseCase: UserUseCase {
    private let service: UserService
    private let currentUserIdUseCase: CurrentUserIdUseCase
    
    init(
        service: UserService = DIContainer.shared.resolve(),
        currentUserIdUseCase: CurrentUserIdUseCase = DefaultCurrentUserIdUseCase()
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
    
    func fetchCurrentUser() async throws -> MolioUser? {
        guard let userID = try currentUserIdUseCase.execute() else { return nil }
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
        return userDTOs.map(\.toEntity)
    }

    func updateUser(
        userID: String,
        newName: String,
        newDescription: String?,
        imageUpdate: ProfileImageUpdateType
    ) async throws {
        let updateImageURLString: String? = switch imageUpdate {
        case .keep:
            try await service.readUser(userID: userID).profileImageURL
        case .update(let imageData):
            try await service.uploadUserImage(userID: userID, data: imageData).absoluteString
        case .remove:
            ""
        }
    }
    
    func deleteUser(userID: String) async throws {
        try await service.deleteUser(userID: userID)
    }
}
