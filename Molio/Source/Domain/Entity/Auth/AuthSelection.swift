/// 사용자가 앱 사용 방식(로그인/비로그인)을 선택했는지 여부를 나타내는 상태 값입니다.
enum AuthSelection: String {
    /// 사용자가 로그인/비로그인 방식을 선택한 상태
    case selected
    
    /// 사용자가 앱 사용 방식을 아직 선택하지 않은 초기 상태
    case unselected
}
