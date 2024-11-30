import Foundation

protocol UserService {
    func createUser(_ user: MolioUserDTO) async throws
    func readUser(userID: String) async throws -> MolioUserDTO
    func updateUser(userID: String, newName: String, newDescription: String?, newImageData: Data?) async throws
    func deleteUser( userID: String) async throws
}
