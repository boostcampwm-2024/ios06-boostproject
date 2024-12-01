import FirebaseStorage
import Foundation

final class FirebaseStorageManager {
    private let storage = Storage.storage()
    
    func uploadImage(
        imageData: Data,
        folder: FolderType,
        userID fileName: String
    ) async throws -> URL {
        
        guard !imageData.isEmpty else {
            throw FirebaseStorageError.invalidImageData
        }
        
        // 1. Storage 경로 생성
        let storagePath = "\(folder)/\(fileName).jpg"
        
        // 2. Storage에 업로드
        let storageRef = storage.reference().child(storagePath)
        _ = try await storageRef.putDataAsync(imageData, metadata: nil)
        
        return try await storageRef.downloadURL()
    }
    
    enum FolderType: String {
        case profileImage
    }
}
