final class DIContainer {
    static let shared = DIContainer()
    private init() {}
    
    private var dependencies: [String: Any] = [:]
    
    /// 의존성 객체를 등록
    ///  - Parameters
    ///     - `type`: 의존성 객체의 타입
    ///     - `dependency`: 의존성 객체 인스턴스
    func register<T>(_ type: T.Type, dependency: Any) {
        let key = "\(type)"
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = "\(type)"
        return dependencies[key] as! T
    }
    
    func resolve<T>() -> T {
        let key = "\(T.self)"
        return dependencies[key] as! T
    }
}
