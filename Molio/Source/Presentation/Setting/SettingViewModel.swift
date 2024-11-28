import Combine
import Foundation

final class SettingViewModel: ObservableObject {
    let authMode: AuthMode
    
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    
    init(manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()) {
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
        
        self.authMode = manageAuthenticationUseCase.getAuthMode()
    }
}
