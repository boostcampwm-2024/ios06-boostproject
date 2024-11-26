import XCTest
import FirebaseStorage
@testable import Molio

final class FirebaseStorageManagerTests: XCTestCase {
    var manager: FirebaseStorageManager!
    let testImage = UIImage(named: "AlbumCoverSample")! // 테스트용 이미지
    let testFolder = "test_images"
    
    override func setUp() {
        super.setUp()
        manager = FirebaseStorageManager()
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }
    
    func testUploadImageSuccess() {
        let expectation = self.expectation(description: "Image upload succeeds")
        
        manager.uploadImage(image: testImage, folder: testFolder) { result in
            switch result {
            case .success(let downloadURL):
                XCTAssertNotNil(downloadURL, "Download URL should not be nil")
                XCTAssertTrue(downloadURL.contains("https://"), "Download URL should be valid")
                print("Download URL: \(downloadURL)")
            case .failure(let error):
                XCTFail("Image upload failed with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUploadImageFailure() {
        let invalidImage = UIImage() // Empty UIImage, invalid for uploading
        let expectation = self.expectation(description: "Image upload fails due to invalid data")
        
        manager.uploadImage(image: invalidImage, folder: testFolder) { result in
            switch result {
            case .success(let downloadURL):
                XCTFail("Upload should not succeed with invalid data, but returned URL: \(downloadURL)")
            case .failure(let error):
                XCTAssertEqual(error as? FirebaseStorageError, FirebaseStorageError.invalidImageData)
                print("Expected failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
