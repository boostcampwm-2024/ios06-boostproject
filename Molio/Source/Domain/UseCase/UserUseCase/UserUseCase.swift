import Foundation

protocol UserUseCase {
    func createUser(userID: String, userName: String, imageURL: URL?, description: String?) async throws
    func fetchUser(userID: String) async throws -> MolioUser
    func fetchFollower(userID: String, state: Bool) async throws -> MolioFollower
    func updateUser(userID: String, newName: String, newDescription: String?, newImageData: Data?) async throws
    func deleteUser(userID: String) async throws
}
