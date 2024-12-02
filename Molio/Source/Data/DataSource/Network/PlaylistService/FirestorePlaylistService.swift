import FirebaseCore
import FirebaseFirestore

final class FirestorePlaylistService: PlaylistService {
    private let db: Firestore
    private let collectionName = "playlists"
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        self.db = Firestore.firestore()
    }
    
    func createPlaylist(playlist: MolioPlaylistDTO) async throws {
        let docRef = getDocumentReference(documentName: playlist.id)

        return try await withCheckedThrowingContinuation { continuation in
            do {
                try docRef.setData(from: playlist) { error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func readPlaylist(playlistID: UUID) async throws -> MolioPlaylistDTO {
        let docRef = getDocumentReference(documentName: playlistID.uuidString)

        return try await docRef.getDocument(as: MolioPlaylistDTO.self)
    }
    
    func readAllPlaylist(userID: String) async throws -> [MolioPlaylistDTO] {
        
        try await db.collection(collectionName)
            .whereField("authorID", isEqualTo: userID)
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: MolioPlaylistDTO.self) }
    }

    func updatePlaylist(newPlaylist: MolioPlaylistDTO) async throws {
        let docRef = getDocumentReference(documentName: newPlaylist.id)
        
        guard let dictionary = newPlaylist.toDictionary() else {
            throw FirestoreError.failedToConvertToDictionary
        }
        
        return try await docRef.updateData(dictionary)
    }
    
    func deletePlaylist(playlistID: UUID) async throws {
        let docRef = db.collection(collectionName).document(playlistID.uuidString)

        return try await docRef.delete()
    }
    
    private func getDocumentReference(documentName: String) -> DocumentReference {
        return db.collection(collectionName).document(documentName)
    }
}
