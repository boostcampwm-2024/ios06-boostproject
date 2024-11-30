import Foundation

final class DefaultAuthStateRepository: AuthStateRepository {
    private var authLocalStorage: AuthLocalStorage
    private let firebaseService: AuthService
    
    init(
        authLocalStorage: AuthLocalStorage = DIContainer.shared.resolve(),
        firebaseService: AuthService = DIContainer.shared.resolve()
    ) {
        self.authLocalStorage = authLocalStorage
        self.firebaseService = firebaseService
    }
    
    var authMode: AuthMode {
        return authLocalStorage.authMode
    }
    
    var authSelection: AuthSelection {
        return authLocalStorage.authSelection
    }
    
    func setAuthMode(_ mode: AuthMode) {
        authLocalStorage.authMode = mode
    }
    
    func setAuthSelection(_ selection: AuthSelection) {
        authLocalStorage.authSelection = selection
    }
    
    func signInApple(info: AppleAuthInfo) async throws {
        try await firebaseService.signInApple(info: info)
    }
    
    func logout() throws {
        try firebaseService.logout()
    }
    
    func reauthenticateApple(idToken: String, nonce: String) async throws {
        try await firebaseService.reauthenticateApple(idToken: idToken, nonce: nonce)
    }
    
    func deleteAuth(authorizationCode: String) async throws {
        try await firebaseService.deleteAccount(authorizationCode: authorizationCode)
    }
}
