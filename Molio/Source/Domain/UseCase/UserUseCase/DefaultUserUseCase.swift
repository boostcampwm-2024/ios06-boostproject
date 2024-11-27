import Foundation

final class DefaultUserUseCase: UserUseCase {
    private let service: UserService
    
    init(
        service: UserService
    ) {
        self.service = service
    }
    
    func createUser(userID: String, userName: String, imageURL: URL?, description: String?) async throws {
        let newUser = MolioUserDTO(
            id: userID,
            name: userName,
            profileImageURL: imageURL?.absoluteString,
            description: description
        )
        try await service.createUser(newUser)
    }
    
    func fetchUser(userID: String) async throws -> MolioUser {
        let userDTO = try await service.readUser(userID: userID)
        
        let user = MolioUser(
            id: userDTO.id,
            name: userDTO.name,
            profileImageURL: userDTO.profileImageURL != nil ? URL(string: userDTO.profileImageURL!) : nil,
            description: userDTO.description
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
