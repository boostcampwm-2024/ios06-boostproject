import Foundation

protocol UserUseCase {
    func createUser(userName: String?) async throws
    func fetchUser(userID: String) async throws -> MolioUser
    func fetchFollower(userID: String, state: Bool) async throws -> MolioFollower
    func fetchAllUsers() async throws -> [MolioUser]
    func updateUserName(userID: String, newName: String) async throws
    func updateUserDescription(userID: String, newDescription: String?) async throws
    func updateUserImage(userID: String, newImageURL: URL?) async throws
    func deleteUser(userID: String) async throws
}
