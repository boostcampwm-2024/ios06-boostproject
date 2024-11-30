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
        
        let profileImageURL: URL?
        if let urlString = userDTO.profileImageURL {
            profileImageURL = URL(string: urlString)
        } else {
            profileImageURL = nil
        }
        
        let user = MolioUser(
            id: userDTO.id,
            name: userDTO.name,
            profileImageURL: profileImageURL,
            description: userDTO.description
        )
        
        return user
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
    
    func updateUserName(userID: String, newName: String) async throws {
        let user = try await service.readUser(userID: userID)
        let newUser = MolioUserDTO(
            id: user.id,
            name: newName,
            profileImageURL: user.profileImageURL,
            description: user.description
        )
        try await service.updateUser(newUser)
    }
    
    func updateUserDescription(userID: String, newDescription: String?) async throws {
        let user = try await service.readUser(userID: userID)
        let newUser = MolioUserDTO(
            id: user.id,
            name: user.name,
            profileImageURL: user.profileImageURL,
            description: newDescription
        )
        try await service.updateUser(newUser)
    }
    
    func updateUserImage(userID: String, newImageURL: URL?) async throws {
        let user = try await service.readUser(userID: userID)
        let newUser = MolioUserDTO(
            id: user.id,
            name: user.name,
            profileImageURL: newImageURL?.absoluteString,
            description: user.description
        )
        try await service.updateUser(newUser)
    }
    
    func deleteUser(userID: String) async throws {
        try await service.deleteUser(userID: userID)
    }
}
