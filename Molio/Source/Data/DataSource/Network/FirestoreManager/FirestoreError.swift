import Foundation

enum FirestoreError: LocalizedError {
    case failedToConvertToDictionary
    case documentFetchError
    case documentNotFound

    var errorDescription: String? {
        switch self {
        case .failedToConvertToDictionary:
            return "딕셔너리로 변환 실패"
        case .documentFetchError:
            return "문서를 가져오는 중 오류 발생"
        case .documentNotFound:
            return "문서를 찾을 수 없음"
        }
    }
}
