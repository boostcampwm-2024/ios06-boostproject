//import XCTest
//import FirebaseFirestore
//import FirebaseCore
//@testable import Molio
//
//final class FirebaseFollowRelationServiceTests: XCTestCase {
//    var service: FollowRelationService!
//    var firestore: Firestore!
//    
//    override func setUp() {
//        super.setUp()
//        
//        // Firebase 초기화
//        firestore = Firestore.firestore()
//        
//        service = FirebaseFollowRelationService(db: firestore)
//        
//        // FirebaseApp이 이미 초기화되었는지 확인
//        if FirebaseApp.app() == nil {
//            FirebaseApp.configure()
//        }
//    }
//    
//    override func tearDown() {
//        service = nil
//        firestore = nil
//        super.tearDown()
//    }
//    
//    func testCreateFollowRelation() async throws {
//        let followerID = "test_create_follower"
//        let followingID = "test_create_following"
//        
//        try await service.createFollowRelation(from: followerID, to: followingID)
//        
//        let relations = try await service.readFollowRelation(followingID: followingID, followerID: followerID, state: nil)
//        
//        XCTAssertEqual(relations.count, 1)
//        XCTAssertEqual(relations.first?.follower, followerID)
//        XCTAssertEqual(relations.first?.following, followingID)
//        XCTAssertFalse(relations.first?.state ?? true)
//        guard let relationId = relations.first?.id else { return }
//        try await service.deleteFollowRelation(relationID: relationId)
//        
//    }
//    
//    func testReadFollowRelation() async throws {
//        let followerID = "test_read_follower"
//        let followingID = "test_read_following"
//        
//        try await service.createFollowRelation(from: followerID, to: followingID)
//        
//        let relation1 = try await service.readFollowRelation(followingID: followingID, followerID: nil, state: nil)
//        let relation2 = try await service.readFollowRelation(followingID: nil, followerID: followerID, state: nil)
//        let relation3 = try await service.readFollowRelation(followingID: nil, followerID: nil, state: true)
//        
//        XCTAssertEqual(relation1.count, 1)
//        XCTAssertEqual(relation2.count, 1)
//        XCTAssertEqual(relation3.count, 1)
//        
//        guard let relationID = relation1.first?.id else { return }
//        try await service.deleteFollowRelation(relationID: relationID)
//    }
//    
//    func testUpdateFollowRelation() async throws {
//        let followerID = "test_update_follower"
//        let followingID = "test_update_following"
//        
//        try await service.createFollowRelation(from: followerID, to: followingID)
//        let relations = try await service.readFollowRelation(followingID: followingID, followerID: followerID, state: nil)
//        guard let relation = relations.first else {
//            XCTFail("Relation should exist")
//            return
//        }
//        
//        try await service.updateFollowRelation(relationID: relation.id, state: true)
//        let updatedRelations = try await service.readFollowRelation(followingID: followingID, followerID: followerID, state: true)
//        
//        XCTAssertEqual(updatedRelations.count, 1)
//        XCTAssertTrue(updatedRelations.first?.state ?? false)
//        
//        guard let relationID = updatedRelations.first?.id else { return }
//        try await service.deleteFollowRelation(relationID: relationID)
//    }
//    
//    func testDeleteFollowRelation() async throws {
//        let followerID = "test_delete_follower"
//        let followingID = "test_delete_following"
//        
//        try await service.createFollowRelation(from: followerID, to: followingID)
//        let relations = try await service.readFollowRelation(followingID: followingID, followerID: followerID, state: nil)
//        guard let relation = relations.first else {
//            XCTFail("Relation should exist")
//            return
//        }
//        
//        try await service.deleteFollowRelation(relationID: relation.id)
//        let updatedRelations = try await service.readFollowRelation(followingID: followingID, followerID: followerID, state: nil)
//        
//        XCTAssertEqual(updatedRelations.count, 0)
//    }
//}
//
