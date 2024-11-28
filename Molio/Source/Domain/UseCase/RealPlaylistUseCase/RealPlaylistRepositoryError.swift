import Foundation

enum RealPlaylistRepositoryError: LocalizedError {
    case playlistNotFoundWithID
    
    var errorDescription: String? {
        switch self {
        case .playlistNotFoundWithID:
            return "UUID에 해당하는 플레이리스트를 찾을 수 없습니다"
        }
    }
}
