/// 사용자가 선택한 인증 모드를 나타내는 상태 값입니다.
enum AuthMode: String {
    /// 로그인 계정으로 앱을 사용하는 상태
    case authenticated
    
    /// 비로그인 계정으로 앱을 사용하는 상태
    case guest
}
