import Foundation

enum FirebaseAuthError: LocalizedError {
    case loginFailed
    case logoutFailed
    case requiresReauthentication
    case userNotFound
    case deleteAccountFailed
    case reauthenticateFailed
    
    var errorDescription: String? {
        switch self {
        case .loginFailed:
            return "로그인 실패"
        case .logoutFailed:
            return "로그인 아웃 실패"
        case .requiresReauthentication:
            return "재인증이 필요함"
        case .userNotFound:
            return "사용자를 찾을 수 없음"
        case .deleteAccountFailed:
            return "계정 탈퇴 실패"
        case .reauthenticateFailed:
            return "재인증 실패"
        }
    }
}
