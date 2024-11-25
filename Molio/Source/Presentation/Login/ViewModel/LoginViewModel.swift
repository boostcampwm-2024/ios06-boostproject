import AuthenticationServices
import Combine
import CryptoKit
import Foundation

final class LoginViewModel: InputOutputViewModel {
    struct Input {
        let authorizationPublisherDidComplete: AnyPublisher<ASAuthorization, Never>
        let skipLoginButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let navigateToNextScreen: AnyPublisher<Void, Never>
        let error: AnyPublisher<String, Never> // TODO: Error에 따른 알림 UI 구현 및 연결
    }
    
    private let signInAppleUseCase: SignInAppleUseCase
    private let manageAuthenticationUseCase: ManageAuthenticationUseCase
    private var currentNonce: String?
    private let navigateToNextScreenPublisher = PassthroughSubject<Void, Never>()
    private let errorPublisher = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        signInAppleUseCase: SignInAppleUseCase = DIContainer.shared.resolve(),
        manageAuthenticationUseCase: ManageAuthenticationUseCase = DIContainer.shared.resolve()
    ) {
        self.signInAppleUseCase = signInAppleUseCase
        self.manageAuthenticationUseCase = manageAuthenticationUseCase
    }
    
    func transform(from input: Input) -> Output {
        input.authorizationPublisherDidComplete
            .compactMap { [weak self] authorization -> AppleAuthInfo? in
                guard let nonce = self?.currentNonce,
                      let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                      let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    return nil
                }
                return AppleAuthInfo(
                    idToken: idTokenString,
                    nonce: nonce,
                    fullName: appleIDCredential.fullName
                )
            }
            .sink { [weak self] appleAuthinfo in
                guard let self else { return }
                Task {
                    do {
                        try await self.signInAppleUseCase.excute(info: appleAuthinfo)
                        self.navigateToNextScreenPublisher.send()
                    } catch {
                        self.errorPublisher.send(error.localizedDescription) // TODO: Error 메시지 지정
                    }
                }
            }
            .store(in: &cancellables)
        
        input.skipLoginButtonDidTap
            .sink { [weak self] _ in
                guard let self else { return }
                self.navigateToNextScreenPublisher.send()
            }
            .store(in: &cancellables)
        
        return Output(
            navigateToNextScreen: navigateToNextScreenPublisher.eraseToAnyPublisher(),
            error: errorPublisher.eraseToAnyPublisher()
        )
    }
    
    func getAppleIDRequest() -> ASAuthorizationAppleIDRequest? {
        /// startSignInWithAppleFlow()에서 애플ID 인증값을 요청할 때 request에 nonce가 포함되서 전달된다. 이 nonce를 통해 FIrebase에서 무결성 검사를 수행한다.
        guard let nonce = randomNonceString() else { return nil }
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        return request
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
}
