import XCTest
@testable import Molio

final class DefaultCurrentPlaylistRepositoryTests: XCTestCase {
    var repository: CurrentPlaylistRepository!
    private let testDefaultsName: String = "testDefaults"
    private var testDefaults: UserDefaults!
    override func setUp() {
        super.setUp()
        testDefaults = UserDefaults(suiteName: testDefaultsName)
        testDefaults.removePersistentDomain(forName: testDefaultsName)
        repository = DefaultCurrentPlaylistRepository(userDefaults: testDefaults)
    }
    
    override func tearDown() {
        repository = nil
        super.tearDown()
    }
    
    func testCurrentPlaylistSubject_currentPlaylist이_저장되어_있는_경우_currentPlaylist을_가진다() {
        let testUUID = UUID()
        testDefaults.set(testUUID.uuidString, forKey: UserDefaultKey.currentPlaylist.rawValue)

        // repository 초기화
        repository = DefaultCurrentPlaylistRepository(userDefaults: testDefaults)

        // Publisher 값 확인
        let expectation = XCTestExpectation(description: "Publisher emits currentPlaylist UUID")
        var receivedValue: UUID?

        let cancellable = repository.currentPlaylistPublisher
            .sink { value in
                receivedValue = value
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValue, testUUID)
        cancellable.cancel()
    }
    
    func testCurrentPlaylistSubject_defaultPlaylist만_저장되어_있는_경우_defaultPlaylist을_가진다() {
        let testUUID = UUID()
        testDefaults.set(testUUID.uuidString, forKey: UserDefaultKey.defaultPlaylist.rawValue)

        // repository 초기화
        repository = DefaultCurrentPlaylistRepository(userDefaults: testDefaults)

        // Publisher 값 확인
        let expectation = XCTestExpectation(description: "Publisher emits currentPlaylist UUID")
        var receivedValue: UUID?

        let cancellable = repository.currentPlaylistPublisher
            .sink { value in
                receivedValue = value
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValue, testUUID)
        cancellable.cancel()
    }
    
    func testCurrentPlaylistSubject_아무것도_저장되어_있지_않으면_Nil을_가진다() {
        let testUUID = UUID()
        
        // repository 초기화
        repository = DefaultCurrentPlaylistRepository(userDefaults: testDefaults)

        // Publisher 값 확인
        let expectation = XCTestExpectation(description: "Publisher emits currentPlaylist UUID")
        var receivedValue: UUID?

        let cancellable = repository.currentPlaylistPublisher
            .sink { value in
                receivedValue = value
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedValue, nil)
        cancellable.cancel()
    }
    
    func testSetCurrentPlaylistSuccessfully() throws {
        let playlistId = UUID()
        XCTAssertNoThrow(try repository.setCurrentPlaylist(playlistId))
        let savedId = testDefaults.string(forKey: UserDefaultKey.currentPlaylist.rawValue)
        XCTAssertEqual(savedId, playlistId.uuidString)
    }
    
    func testSetDefaultPlaylistSuccessfully() throws {
        let defaultPlaylistId = UUID()
        XCTAssertNoThrow(try repository.setDefaultPlaylist(defaultPlaylistId))
        let savedId = testDefaults.string(forKey: UserDefaultKey.defaultPlaylist.rawValue)
        XCTAssertEqual(savedId, defaultPlaylistId.uuidString)
    }
    
    func testCurrentPlaylistPublisherUpdates() throws {
        let expectation = XCTestExpectation(description: "Publisher should emit new value")
        
        let newPlaylistId = UUID()
        var receivedId: UUID?
        
        let cancellable = repository.currentPlaylistPublisher
            .sink { id in
                receivedId = id
                expectation.fulfill()
            }
        
        try repository.setCurrentPlaylist(newPlaylistId)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedId, newPlaylistId)
        cancellable.cancel()
    }
}
