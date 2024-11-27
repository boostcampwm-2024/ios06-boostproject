import XCTest
import FirebaseFirestore
import FirebaseCore
@testable import Molio

final class FirebaseUserServiceTests: XCTestCase {
    var userService: FirebaseUserService!
    var firestore: Firestore!
    var storageManager: FirebaseStorageManager!
    
    override func setUp() {
        super.setUp()
        
        // Firebase 초기화
        firestore = Firestore.firestore()
        storageManager = FirebaseStorageManager()
        
        userService = FirebaseUserService(
            storageManager: storageManager,
            db: firestore
        )
        
        // FirebaseApp이 이미 초기화되었는지 확인
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    override func tearDown() {
        userService = nil
        firestore = nil
        storageManager = nil
        super.tearDown()
    }
    
    func testCreateUser() async throws {
        let testUser = MolioUserDTO(
            id: "testUserID",
            name: "John Doe",
            profileImageURL: "https://example.com/image.jpg",
            description: "This is a test user"
        )
        
        do {
            try await userService.createUser(testUser)
            
            // Firebase에서 데이터 확인
            let fetchedUser = try await userService.readUser(userID: testUser.id)
            
            XCTAssertEqual(fetchedUser.id, testUser.id)
            XCTAssertEqual(fetchedUser.name, testUser.name)
            XCTAssertEqual(fetchedUser.profileImageURL, testUser.profileImageURL)
            XCTAssertEqual(fetchedUser.description, testUser.description)
        } catch {
            XCTFail("Failed to create user: \(error)")
        }
    }
    
    func testReadUser() async throws {
        let testUser = MolioUserDTO(
            id: "readTestUserID",
            name: "Jane Doe",
            profileImageURL: "https://example.com/image.jpg",
            description: "This is a test read user"
        )
        
        // Pre-populate Firestore with test data
        try await userService.createUser(testUser)
        
        do {
            let fetchedUser = try await userService.readUser(userID: testUser.id)
            
            XCTAssertEqual(fetchedUser.id, testUser.id)
            XCTAssertEqual(fetchedUser.name, testUser.name)
            XCTAssertEqual(fetchedUser.profileImageURL, testUser.profileImageURL)
            XCTAssertEqual(fetchedUser.description, testUser.description)
        } catch {
            XCTFail("Failed to read user: \(error)")
        }
    }
    
    func testUpdateUser() async throws {
        let testUser = MolioUserDTO(
            id: "updateTestUserID",
            name: "Original Name",
            profileImageURL: "https://example.com/image.jpg",
            description: "Original description"
        )
        
        // Create initial user
        try await userService.createUser(testUser)
        
        // Update user
        let updatedUser = MolioUserDTO(
            id: testUser.id,
            name: "Updated Name",
            profileImageURL: "https://example.com/updated_image.jpg",
            description: "Updated description"
        )
        
        do {
            try await userService.updateUser(updatedUser)
            let fetchedUser = try await userService.readUser(userID: updatedUser.id)
            
            XCTAssertEqual(fetchedUser.name, updatedUser.name)
            XCTAssertEqual(fetchedUser.profileImageURL, updatedUser.profileImageURL)
            XCTAssertEqual(fetchedUser.description, updatedUser.description)
        } catch {
            XCTFail("Failed to update user: \(error)")
        }
    }
    
    func testDeleteUser() async throws {
        let testUser = MolioUserDTO(
            id: "deleteTestUserID",
            name: "To Be Deleted",
            profileImageURL: "https://example.com/image.jpg",
            description: "This user will be deleted"
        )
        
        // Create user
        try await userService.createUser(testUser)
        
        // Delete user
        do {
            try await userService.deleteUser(userID: testUser.id)
            
            do {
                _ = try await userService.readUser(userID: testUser.id)
                XCTFail("User should have been deleted, but was found.")
            } catch {
                // Expected behavior
            }
        } catch {
            XCTFail("Failed to delete user: \(error)")
        }
    }
}
