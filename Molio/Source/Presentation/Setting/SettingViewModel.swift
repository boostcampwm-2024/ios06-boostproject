import Combine
import Foundation

final class SettingViewModel: ObservableObject {
    @Published var authMode: AuthMode
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "버전 정보 없음"
    }
    
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    
    init(manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()) {
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
        
        self.authMode = manageAuthenticationUseCase.getAuthMode()
    }
    
    func logout() {
        do {
            try manageAuthenticationUseCase.logout()
            authMode = manageAuthenticationUseCase.getAuthMode()
            print("성공임?")
            // TODO: 성공 Alret 추가
        } catch {
            print("실패임?")
            // TODO: 실패 Alret 추가
        }
    }
}
