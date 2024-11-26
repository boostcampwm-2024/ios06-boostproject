import Foundation

final class DefaultAuthStateRepository: AuthStateRepository {
    private var authLocalStorage: AuthLocalStorage
    
    init(authLocalStorage: AuthLocalStorage = DIContainer.shared.resolve()) {
        self.authLocalStorage = authLocalStorage
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
}
