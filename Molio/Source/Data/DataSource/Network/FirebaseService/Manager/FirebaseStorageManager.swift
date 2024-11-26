import FirebaseStorage
import UIKit

final class FirebaseStorageManager {
    private let storage = Storage.storage()
    
    func uploadImage(
        image: UIImage,
        folder: String,
        fileName: String = UUID().uuidString,
        completion: @escaping (Result <String, Error>) -> Void
    ) {
        // 1. UIImage -> Data로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(FirebaseStorageError.invalidImageData))
            return
        }
        
        // 2. Storage 경로 생성
        let storagePath = "\(folder)/\(fileName).jpg"
        
        // 3. Storage에 업로드
        let storageRef = storage.reference().child(storagePath)
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 4. 업로드 완료 후 다운로드 URL 가져오기
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

