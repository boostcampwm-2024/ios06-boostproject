import Combine
import Foundation

final class SettingViewModel: ObservableObject {
    let authMode: AuthMode
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "버전 정보 없음"
    }
    
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    
    init(manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()) {
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
        
        self.authMode = manageAuthenticationUseCase.getAuthMode()
    }
}
