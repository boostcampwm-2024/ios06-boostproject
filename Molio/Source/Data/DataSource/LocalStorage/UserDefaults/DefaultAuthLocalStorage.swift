import Foundation

struct DefaultAuthLocalStorage: AuthLocalStorage {
    private let userDefault = UserDefaults.standard
    private let authModeKey: String = "auth_mode"
    private let authSelectionKey: String = "auth_selection"
    
    var authMode: AuthMode {
        get {
            let rawValue = userDefault.string(forKey: authModeKey) ?? ""
            return AuthMode(rawValue: rawValue) ?? .guest
        }
        set {
            userDefault.set(newValue.rawValue, forKey: authModeKey)
        }
    }
    
    var authSelection: AuthSelection {
        get {
            let rawValue = userDefault.string(forKey: authSelectionKey) ?? ""
            return AuthSelection(rawValue: rawValue) ?? .unselected
        }
        set {
            userDefault.set(newValue.rawValue, forKey: authSelectionKey)
        }
    }
}
