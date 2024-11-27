import Foundation

protocol UserUseCase {
    func createUser(userID: String, userName: String, description: String?, imageURL: URL?) async throws
    func fetchUser(userID: String) async throws -> MolioUser
    func updateUserName(userID: String, newName: String) async throws
    func updateUserDescription(userID: String, newDescription: String?) async throws
    func updateUserImage(userID: String, newImageURL: URL?) async throws
    func deleteUser(userID: String) async throws
}
