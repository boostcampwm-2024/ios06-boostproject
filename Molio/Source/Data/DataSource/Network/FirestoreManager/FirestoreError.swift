import Foundation

enum FirestoreError: LocalizedError {
    case failedToConvertToDictionary
    case documentFetchError
    case documentNotFound
    case notLoggedIn
    case noSuchUserID
    case noSuchPlaylistID

    var errorDescription: String? {
        switch self {
        case .failedToConvertToDictionary:
            return "딕셔너리로 변환 실패"
        case .documentFetchError:
            return "문서를 가져오는 중 오류 발생"
        case .documentNotFound:
            return "문서를 찾을 수 없음"
        case .notLoggedIn:
            return "로그인 되어 있지 않음"
        case .noSuchUserID:
            return "현재 로그인되어있는 ID에 해당하는 유저 ID가 파이어스토어에 없음"
        case .noSuchPlaylistID:
            return "해당하는 플레이리스트 ID가 파이어스토어에 없음"
        }
    }
}
