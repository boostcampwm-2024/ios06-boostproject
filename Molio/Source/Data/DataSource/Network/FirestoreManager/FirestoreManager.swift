import FirebaseCore
import FirebaseFirestore

final class FirestoreManager {
    private let db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
    
    func create<T: FirebaseDataModel>(entity: T) async throws {
        guard let entityDictionary = entity.toDictionary else {
            throw FirestoreError.failedToConvertToDictionary
        }
        
        try await db.collection(T.collectionName).addDocument(data: entityDictionary)
    }
    
    func read<T: FirebaseDataModel & Decodable>(entityType: T.Type, id: String) async throws -> T? {
        let document = db.collection(entityType.collectionName)
            .whereField(entityType.firebaseIDFieldName, isEqualTo: id)
        
        let snapshot = try await document.getDocuments()
        
        guard let document = snapshot.documents.first else {
            return nil
        }
        
        return try document.data(as: T.self)
    }
}
