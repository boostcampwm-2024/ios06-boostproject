import XCTest
import CoreData
@testable import Molio

final class DefaultPlaylistRepositoryTests: XCTestCase {
    var repository: DefaultPlaylistRepository!
    var context: NSManagedObjectContext!
    let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()

    override func setUp() {
        super.setUp()
        context = TestPersistenceManager.shared.context
        repository = DefaultPlaylistRepository(context: context)
        
    }
    
    override func tearDown() {
        repository = nil
        context = nil
        super.tearDown()
    }
    
    func testSaveNewPlaylist() async throws {
        let playlistName: String = "TestPlaylist"
        
        let _ = try await repository.saveNewPlaylist(playlistName)
                
        let playlist = repository.fetchPlaylist(for: playlistName)
        
        XCTAssertEqual(playlist?.name, playlistName)
    }
    
    func testAddMusic() async throws {
        let playlistName: String = "AddMusicPlaylist"
        let testISRC = "TEST_ISRC"
        
        let _ = try await repository.saveNewPlaylist(playlistName)
        repository.addMusic(isrc: testISRC, to: playlistName)
        
        guard let playlist = repository.fetchPlaylist(for: playlistName)else { return }
        
        let musics = playlist.musicISRCs
        
        XCTAssertEqual(musics.count, 1)
        XCTAssertEqual(musics.first, testISRC)
    }
    
    func testDeleteMusic() {
        let playlistName: String = "AddMusicPlaylist"
        let testISRC = "TEST_ISRC"
        
        repository.addMusic(isrc: testISRC, to: playlistName)
        repository.deleteMusic(isrc: testISRC, in: playlistName)
        
        let musics = repository.fetchPlaylist(for: playlistName)?.musicISRCs
        XCTAssertTrue(musics?.isEmpty ?? false)
    }
    
    func testFetchMusics() async throws {
        let playlistName: String = "FetchMusicsPlaylist"
        let _ = try await repository.saveNewPlaylist(playlistName)
        
        repository.addMusic(isrc: "MUSIC_1", to: playlistName)
        repository.addMusic(isrc: "MUSIC_2", to: playlistName)

        let musics = repository.fetchPlaylist(for: playlistName)?.musicISRCs
        XCTAssertEqual(musics?.count, 2)
        XCTAssertEqual(musics?[0], "MUSIC_1")
        XCTAssertEqual(musics?[1], "MUSIC_2")
    }
    
    func testMoveMusic() async throws {
        let playlistName: String = "MoveMusicPlaylist"
        let _ = try await repository.saveNewPlaylist(playlistName)

        repository.addMusic(isrc: "MUSIC_1", to: playlistName)
        repository.addMusic(isrc: "MUSIC_2", to: playlistName)

        repository.moveMusic(isrc: "MUSIC_1", in: playlistName, fromIndex: 0, toIndex: 1)

        let musics = repository.fetchPlaylist(for: playlistName)?.musicISRCs
        XCTAssertEqual(musics?[0], "MUSIC_2")
        XCTAssertEqual(musics?[1], "MUSIC_1")
    }
    
    func testDeletePlaylist() async throws {
        let playlistName: String = "DeletePlaylist"
        let _ = try await repository.saveNewPlaylist(playlistName)
        let id = repository.fetchPlaylist(for: playlistName)?.id
        print(id ?? "nil")

        repository.deletePlaylist(playlistName)
        let currId = repository.fetchPlaylist(for: playlistName)?.id

        XCTAssertEqual(currId, nil)

    }
}

final class TestPersistenceManager {
    static let shared = TestPersistenceManager()
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        let persistentContainer = NSPersistentContainer(name: "MolioModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // 인메모리로 설정
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory Core Data stack: \(error)")
            }
        }
        return persistentContainer.viewContext
    }()
}
