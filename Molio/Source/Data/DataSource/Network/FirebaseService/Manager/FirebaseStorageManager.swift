import FirebaseStorage
import Foundation

final class FirebaseStorageManager {
    private let storage = Storage.storage()
    
    func uploadImage(
        imageData: Data,
        folder: String,
        fileName: String = UUID().uuidString,
        completion: @escaping (Result <String, Error>) -> Void
    ) {
        
        guard !imageData.isEmpty else {
            completion(.failure(FirebaseStorageError.invalidImageData))
            return
        }
        
        // 1. Storage 경로 생성
        let storagePath = "\(folder)/\(fileName).jpg"
        
        // 2. Storage에 업로드
        let storageRef = storage.reference().child(storagePath)
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 3. 업로드 완료 후 다운로드 URL 가져오기
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(FirebaseStorageError.notFound))
                }
            }
        }
    }
}

