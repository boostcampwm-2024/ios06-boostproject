protocol AuthStateRepository {
    var authMode: AuthMode { get }
    var authSelection: AuthSelection { get }
    func setAuthMode(_ mode: AuthMode)
    func setAuthSelection(_ selection: AuthSelection)
    func signInApple(info: AppleAuthInfo) async throws
    func logout() throws
    func deleteAuth() async throws
}
