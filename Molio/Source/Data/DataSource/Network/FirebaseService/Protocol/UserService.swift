import Foundation

protocol UserService {
    func createUser(_ user: MolioUserDTO) async throws
    func readUser(userID: String) async throws -> MolioUserDTO
    func updateUser(_ user: MolioUserDTO) async throws
    func deleteUser( userID: String) async throws
    func uploadUserImage(userID: String, data: Data) async throws -> URL
}
