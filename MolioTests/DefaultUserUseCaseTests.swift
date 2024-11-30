//import XCTest
//@testable import Molio
//
//final class DefaultUserUseCaseTests: XCTestCase {
//    var userUseCase: DefaultUserUseCase!
//    var mockService: MockUserService!
//    
//    override func setUp() {
//        super.setUp()
//        mockService = MockUserService()
//        userUseCase = DefaultUserUseCase(service: mockService)
//    }
//    
//    override func tearDown() {
//        userUseCase = nil
//        mockService = nil
//        super.tearDown()
//    }
//    
//    func testCreateUser() async throws {
//        let userID = "testUserID"
//        let userName = "Test User"
//        let imageURL = URL(string: "https://example.com/image.jpg")
//        let description = "This is a test user."
//
//        try await userUseCase.createUser(userName: userName)
//        
//        XCTAssertEqual(mockService.createdUser?.name, userName)
//    }
//    
//    func testFetchUser() async throws {
//        let expectedUser = MolioUserDTO(
//            id: "testUserID",
//            name: "Test User",
//            profileImageURL: "https://example.com/image.jpg",
//            description: "Test Description"
//        )
//        
//        mockService.mockedUser = expectedUser
//        
//        let user = try await userUseCase.fetchUser(userID: "testUserID")
//        
//        XCTAssertEqual(user.id, expectedUser.id)
//        XCTAssertEqual(user.name, expectedUser.name)
//        XCTAssertEqual(user.profileImageURL?.absoluteString, expectedUser.profileImageURL)
//        XCTAssertEqual(user.description, expectedUser.description)
//    }
//    
//    func testUpdateUserName() async throws {
//        let userID = "testUserID"
//        let newName = "Updated Name"
//        
//        let existingUser = MolioUserDTO(
//            id: userID,
//            name: "Old Name",
//            profileImageURL: "https://example.com/image.jpg",
//            description: "Test Description"
//        )
//        
//        mockService.mockedUser = existingUser
//        
//        try await userUseCase.updateUserName(userID: userID, newName: newName)
//        
//        XCTAssertEqual(mockService.updatedUser?.name, newName)
//        XCTAssertEqual(mockService.updatedUser?.profileImageURL, existingUser.profileImageURL)
//        XCTAssertEqual(mockService.updatedUser?.description, existingUser.description)
//    }
//    
//    func testUpdateUserDescription() async throws {
//        let userID = "testUserID"
//        let newDescription = "Updated Description"
//        
//        let existingUser = MolioUserDTO(
//            id: userID,
//            name: "Test User",
//            profileImageURL: "https://example.com/image.jpg",
//            description: "Old Description"
//        )
//        
//        mockService.mockedUser = existingUser
//        
//        try await userUseCase.updateUserDescription(userID: userID, newDescription: newDescription)
//        
//        XCTAssertEqual(mockService.updatedUser?.description, newDescription)
//        XCTAssertEqual(mockService.updatedUser?.name, existingUser.name)
//        XCTAssertEqual(mockService.updatedUser?.profileImageURL, existingUser.profileImageURL)
//    }
//    
//    func testUpdateUserImage() async throws {
//        let userID = "testUserID"
//        let newImageURL = URL(string: "https://example.com/newImage.jpg")
//        
//        let existingUser = MolioUserDTO(
//            id: userID,
//            name: "Test User",
//            profileImageURL: "https://example.com/image.jpg",
//            description: "Test Description"
//        )
//        
//        mockService.mockedUser = existingUser
//        
//        try await userUseCase.updateUserImage(userID: userID, newImageURL: newImageURL)
//        
//        XCTAssertEqual(mockService.updatedUser?.profileImageURL, newImageURL?.absoluteString)
//        XCTAssertEqual(mockService.updatedUser?.name, existingUser.name)
//        XCTAssertEqual(mockService.updatedUser?.description, existingUser.description)
//    }
//    
//    func testDeleteUser() async throws {
//        let userID = "testUserID"
//        
//        try await userUseCase.deleteUser(userID: userID)
//        
//        XCTAssertEqual(mockService.deletedUserID, userID)
//    }
//}
//
//final class MockUserService: UserService {
//    var createdUser: MolioUserDTO?
//    var mockedUser: MolioUserDTO?
//    var updatedUser: MolioUserDTO?
//    var deletedUserID: String?
//    
//    func createUser(_ user: MolioUserDTO) async throws {
//        createdUser = user
//    }
//    
//    func readUser(userID: String) async throws -> MolioUserDTO {
//        guard let mockedUser = mockedUser else {
//            throw NSError(domain: "User not found", code: 404, userInfo: nil)
//        }
//        return mockedUser
//    }
//    
//    func updateUser(_ user: MolioUserDTO) async throws {
//        updatedUser = user
//    }
//    
//    func deleteUser(userID: String) async throws {
//        deletedUserID = userID
//    }
//}
