import XCTest
import CoreData
@testable import Molio

final class CoreDataPlaylistStorageTests: XCTestCase {
    var storage: CoreDataPlaylistStorage!
    var context: NSManagedObjectContext!
    let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()

    override func setUp() {
        super.setUp()
        context = TestPersistenceManager.shared.newInMemoryContext()
        storage = CoreDataPlaylistStorage(context: context)
        
    }
    
    override func tearDown() {
        storage = nil
        context = nil
        super.tearDown()
    }
    
    func testCreatePlaylist() async throws {
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Test Playlist",
            createdAt: Date(),
            musicISRCs: ["ISRC001", "ISRC002"],
            filter: MusicFilter(genres: [.pop])
        )

        try await storage.create(playlist)
        
        let fetchedPlaylist = try await storage.read(by: playlist.id.uuidString)
        
        XCTAssertNotNil(fetchedPlaylist)
        XCTAssertEqual(fetchedPlaylist?.name, playlist.name)
        XCTAssertEqual(fetchedPlaylist?.musicISRCs, playlist.musicISRCs)
        XCTAssertEqual(fetchedPlaylist?.filter.genres, playlist.filter.genres)
    }

    func testReadPlaylist() async throws {
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Sample Playlist",
            createdAt: Date(),
            musicISRCs: ["ISRC123"],
            filter: MusicFilter(genres: [.pop])
        )

        try await storage.create(playlist)

        let fetchedPlaylist = try await storage.read(by: playlist.id.uuidString)
        XCTAssertNotNil(fetchedPlaylist)
        XCTAssertEqual(fetchedPlaylist?.id, playlist.id)
        XCTAssertEqual(fetchedPlaylist?.name, playlist.name)
        XCTAssertEqual(fetchedPlaylist?.musicISRCs, playlist.musicISRCs)
        XCTAssertEqual(fetchedPlaylist?.filter.genres, playlist.filter.genres)
    }

    func testReadAllPlaylists() async throws {
        let playlist1 = MolioPlaylist(
            id: UUID(),
            name: "Playlist 1",
            createdAt: Date(),
            musicISRCs: ["ISRC001"],
            filter: MusicFilter(genres: [.pop])
        )

        let playlist2 = MolioPlaylist(
            id: UUID(),
            name: "Playlist 2",
            createdAt: Date(),
            musicISRCs: ["ISRC002", "ISRC003"],
            filter: MusicFilter(genres: [.pop])
        )

        try await storage.create(playlist1)
        try await storage.create(playlist2)

        let playlists = try await storage.readAll()
        XCTAssertEqual(playlists.count, 2)
        XCTAssertTrue(playlists.contains { $0.id == playlist1.id })
        XCTAssertTrue(playlists.contains { $0.id == playlist2.id })
    }

    func testUpdatePlaylist() async throws {
        let uuid = UUID()
        let playlist = MolioPlaylist(
            id: uuid,
            name: "Old Playlist Name",
            createdAt: Date(),
            musicISRCs: ["ISRC001"],
            filter: MusicFilter(genres: [.pop])
        )

        try await storage.create(playlist)
        
        let updatedPlaylist = MolioPlaylist(
            id: uuid,
            name: "Updated Playlist Name",
            createdAt: Date(),
            musicISRCs: ["ISRC004"],
            filter: MusicFilter(genres: [.pop])
        )

        try await storage.update(updatedPlaylist)
        let fetchedPlaylist = try await storage.read(by: updatedPlaylist.id.uuidString)
        XCTAssertNotNil(fetchedPlaylist)
        
        XCTAssertEqual(fetchedPlaylist?.name, updatedPlaylist.name)
        XCTAssertEqual(fetchedPlaylist?.musicISRCs, updatedPlaylist.musicISRCs)
        XCTAssertEqual(fetchedPlaylist?.filter.genres, updatedPlaylist.filter.genres)
    }

    func testDeletePlaylist() async throws {
        let playlist = MolioPlaylist(
            id: UUID(),
            name: "Playlist to Delete",
            createdAt: Date(),
            musicISRCs: ["ISRC001"],
            filter: MusicFilter(genres: [.pop])
        )

        try await storage.create(playlist)

        try await storage.delete(by: playlist.id.uuidString)

        let fetchedPlaylist = try await storage.read(by: playlist.id.uuidString)
        XCTAssertNil(fetchedPlaylist)
    }
}

final class TestPersistenceManager {
    static let shared = TestPersistenceManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MolioModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory Core Data stack: \(error)")
            }
        }
        return container
    }()

    func newInMemoryContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}
