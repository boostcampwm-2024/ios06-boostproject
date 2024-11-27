import Foundation

enum MusicKitError: LocalizedError {
    case deniedPermission
    case restricted
    case failedSubscriptionCheck
    case didNotSubscribe
    
    var errorDescription: String? {
        switch self {
        case .deniedPermission: "Apple Music 접근 권한을 승인하지 않았습니다."
        case .restricted: "현재 디바이스에서 Apple Music 서비스를 이용할 수 없습니다."
        case .failedSubscriptionCheck: "Apple Music 구독 여부 확인에 실패했습니다."
        case .didNotSubscribe: "Apple Music을 구독하고 있지 않습니다."
        }
    }
}
