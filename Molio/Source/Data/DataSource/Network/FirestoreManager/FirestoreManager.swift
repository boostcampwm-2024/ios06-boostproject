import FirebaseCore
import FirebaseFirestore

final class FirestoreManager {
    private let db: Firestore
    
    init(
        db: Firestore = Firestore.firestore()
    ) {
        self.db = db
    }
    
    // MARK: - CREATE
    
    func create<T: FirestoreEntity>(entity: T) async throws {
        guard let entityDictionary = entity.toDictionary else {
            throw FirestoreError.failedToConvertToDictionary
        }
        
        try await db.collection(T.collectionName).addDocument(data: entityDictionary)
    }

    // MARK: - READ

    func read<T: FirestoreEntity & Decodable>(entityType: T.Type, id: String) async throws -> T? {
        let query = db.collection(entityType.collectionName)
            .whereField(entityType.firebaseIDFieldName, isEqualTo: id)
        
        let documentSnapshot = try await getFirstDocumentSnapshot(query: query)

        return try documentSnapshot.data(as: T.self)
    }
        
    func readAll<T: FirestoreEntity & Decodable>(entityType: T.Type) async throws -> [T] {
        let query = try await db.collection(entityType.collectionName).getDocuments()
        
        return query.documents.compactMap { document in
            try? document.data(as: T.self)
        }
    }
    
    // MARK: - UPDATE

    func update<T: FirestoreEntity>(entity: T) async throws {
        let idString = entity.idString
        
        guard let newEntityDictionary = entity.toDictionary else {
            throw FirestoreError.failedToConvertToDictionary
        }
        
        let query = db.collection(T.collectionName).whereField(T.firebaseIDFieldName, isEqualTo: idString)
        
        let documentSnapshot = try await getFirstDocumentSnapshot(query: query)

        try await documentSnapshot.reference.updateData(newEntityDictionary)
    }
    
    // MARK: - DELETE
    
    func delete<T: FirestoreEntity>(entityType: T.Type, idString: String) async throws {
        let query = db.collection(T.collectionName).whereField(T.firebaseIDFieldName, isEqualTo: idString)

        let documentSnapshot = try await getFirstDocumentSnapshot(query: query)
        
        try await documentSnapshot.reference.delete()
    }
    
    private func getFirstDocumentSnapshot(query: Query) async throws -> DocumentSnapshot {
        let snapshot = try await query.getDocuments()
        
        guard let documentSnapshot = snapshot.documents.first else {
            throw FirestoreError.documentNotFound
        }
        
        return documentSnapshot
    }
}
