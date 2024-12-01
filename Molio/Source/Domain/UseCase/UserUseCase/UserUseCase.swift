import Foundation

protocol UserUseCase {
    func createUser(userName: String?) async throws
    func fetchCurrentUser() async throws -> MolioUser? 
    func fetchUser(userID: String) async throws -> MolioUser
    func fetchAllUsers() async throws -> [MolioUser]
    func updateUser(userID: String, newName: String, newDescription: String?, imageUpdate: ProfileImageUpdateType) async throws
    func deleteUser(userID: String) async throws
}
