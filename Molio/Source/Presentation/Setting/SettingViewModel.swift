import Combine
import Foundation

final class SettingViewModel: ObservableObject {
    @Published var authMode: AuthMode
    @Published var showAlert = false
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "버전 정보 없음"
    }
    
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    var alertState: AlertType = .successLogout
    
    init(manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()) {
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
        
        self.authMode = manageAuthenticationUseCase.getAuthMode()
    }
    
    func logout() {
        do {
            try manageAuthenticationUseCase.logout()
            authMode = manageAuthenticationUseCase.getAuthMode()
            alertState = .successLogout
            showAlert = true
        } catch {
            alertState = .failureLogout
            showAlert = true
        }
    }
    
    enum AlertType {
        case successLogout
        case failureLogout
        
        var title: String {
            switch self {
            case .successLogout:
                "로그아웃 완료되었습니다."
            case .failureLogout:
                "로그아웃할 수 없습니다."
            }
        }
    }
}
