import AuthenticationServices
import Combine
import CryptoKit
import Foundation

protocol SettingViewModelDelegate: AnyObject {
    func requestAppleCredentials(completion: @escaping (String, String) -> Void)
}

final class SettingViewModel: ObservableObject {
    @Published var isLogin: Bool
    @Published var showAlert = false
    
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    weak var delegate: SettingViewModelDelegate?
    var alertState: AlertType = .successLogout
    var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "버전 정보 없음"
    }
    
    init(manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()) {
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
        
        self.isLogin = manageAuthenticationUseCase.isLogin()
    }
    
    func logout() {
        do {
            try manageAuthenticationUseCase.logout()
            isLogin = manageAuthenticationUseCase.isLogin()
            alertState = .successLogout
            showAlert = true
        } catch {
            alertState = .failureLogout
            showAlert = true
        }
    }
    
    func deleteAccount() {
        delegate?.requestAppleCredentials { [weak self] identityToken, authCode in
            guard let self,
                  let nonce = randomNonceString() else { return }
            Task {
                do {
                    try await self.manageAuthenticationUseCase.deleteAuth(
                        idToken: identityToken,
                        nonce: nonce,
                        authorizationCode: authCode
                    )
                    await MainActor.run {
                        self.isLogin = self.manageAuthenticationUseCase.isLogin()
                        self.alertState = .successDeleteAccount
                        self.showAlert = true
                    }
                } catch {
                    self.alertState = .failureDeleteAccount
                    self.showAlert = true
                }
            }
        }
    }
    
    // MARK: - 암호로 보호된 nonce를 생성
    /// 로그인 요청마다 임의의 문자열인 'nonce'가 생성되며, 이 nonce는 앱의 인증 요청에 대한 응답으로 ID 토큰이 명시적으로 부여되었는지 확인하는 데 사용된다.
    /// 재전송 공격을 방지하려면 이 단계가 필요
    private func randomNonceString(length: Int = 32) -> String? {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            return nil
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    /// 로그인 요청과 함께 nonce의 SHA256 해시를 전송하면 Apple은 이에 대한 응답으로 원래의 값을 전달합니다. Firebase는 원래의 nonce를 해싱하고 Apple에서 전달한 값과 비교하여 응답을 검증합니다.
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    enum AlertType {
        case successLogout
        case failureLogout
        case successDeleteAccount
        case failureDeleteAccount
        
        var title: String {
            switch self {
            case .successLogout:
                "로그아웃 완료되었습니다."
            case .failureLogout:
                "로그아웃할 수 없습니다."
            case .successDeleteAccount:
                "계정이 탈퇴되었습니다."
            case .failureDeleteAccount:
                "계정탈퇴에 실패했습니다."
            }
        }
    }
}
