import FirebaseStorage
import FirebaseCore
import FirebaseFirestore

final class FirebaseFollowRelationService: FollowRelationService {
    private let db: Firestore
    private let collectionName: String = "followRelations"
    
    init(
        db: Firestore
    ) {
        self.db = db
        
        // FirebaseApp이 이미 초기화되었는지 확인
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
    }
    
    func createUser(_ user: MolioUserDTO) async throws {
        guard let userData = user.toDictionary() else { return }
        
        let docRef = getDocumentReference(documentName: user.id)
        try await docRef.setData(userData)
    }
    
    func readUser(userID: String) async throws -> MolioUserDTO {
        let docRef = getDocumentReference(documentName: userID)
        return try await docRef.getDocument(as: MolioUserDTO.self)
    }
    
    func updateUser(_ user: MolioUserDTO) async throws {
        guard let updateUserData = user.toDictionary() else { return } // TODO: 딕셔너리 반환 에러 throw
        let docRef = getDocumentReference(documentName: user.id)

        try await docRef.updateData(updateUserData)
    }
    
    func deleteUser(userID: String) async throws {
        let docRef = getDocumentReference(documentName: userID)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            docRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    func createFollowRelation(from followerID: String, to followingID: String) async throws {
        let newFollowingRelation = FollowRelationDTO(
            id: UUID().uuidString,
            date: Date(),
            following: followingID,
            follower: followerID,
            state: false)
        
        guard let newFollowingRelationData = newFollowingRelation.toDictionary() else { return } // TODO: throw 추가 - 딕셔너리 변환 실패
        
        let docRef = getDocumentReference(documentName: newFollowingRelation.id)
        try await docRef.setData(newFollowingRelationData)
    }
    
    func readFollowRelation(followingID: String?, followerID: String?, state: Bool?) async throws -> [FollowRelationDTO] {
        var query: Query = db.collection(collectionName)

        if let followingID = followingID {
            query = query.whereField("following", isEqualTo: followingID)
        }
        if let followerID = followerID {
            query = query.whereField("follower", isEqualTo: followerID)
        }
        if let state = state {
            query = query.whereField("state", isEqualTo: state)
        }

        return try await withCheckedThrowingContinuation { continuation in
            query.getDocuments { snapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let documents = snapshot?.documents else {
                    continuation.resume(returning: [])
                    return
                }

                do {
                    let relations: [FollowRelationDTO] = try documents.map {
                        let jsonData = try JSONSerialization.data(withJSONObject: $0.data())
                        return try JSONDecoder().decode(FollowRelationDTO.self, from: jsonData)
                    }
                    continuation.resume(returning: relations)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func updateFollowRelation(relationID: String, state: Bool) async throws {
        let docRef = getDocumentReference(documentName: relationID)
        let updateData: [String: Any] = ["state": state]
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>)  in
            docRef.updateData(updateData) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    
    func deleteFollowRelation(relationID: String) async throws {
        let docRef = getDocumentReference(documentName: relationID)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            docRef.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    
    // MARK: - Private Method
    
    private func getDocumentReference(documentName: String) -> DocumentReference {
        return db.collection(collectionName).document(documentName)
    }
}
