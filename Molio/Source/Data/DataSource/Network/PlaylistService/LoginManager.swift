/// 현재 로그인 되어 있는 유저의 ID를 주는 인터페이스
protocol LoginManager {
    func getCurrentUserID() -> String?
}
