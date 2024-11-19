final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    private var dependencies: [String: Any] = [:]
    
    /// 의존성 등록
    ///  - Parameters
    ///     - `type`: 의존성 객체의 타입
    ///     - `dependency`: 의존성 객체 인스턴스
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = "\(type)"
        dependencies[key] = dependency
    }
    
    /// 파라미터로 타입을 직접 지정하여 의존성 불러오기
    func resolve<T>(_ type: T.Type) -> T {
        let key = "\(type)"
        return dependencies[key] as! T
    }
    
    /// 파라미터 없이 의존성 불러오기
    /// - 할당받는 쪽에서 타입 지정 필요
    func resolve<T>() -> T {
        let key = "\(T.self)"
        return dependencies[key] as! T
    }
}
