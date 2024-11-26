enum FirebaseError: Error {
    case loginFail

    var errorDescription: String? {
        switch self {
        case .loginFail:
            return "로그인 실패"
        }
    }
}
