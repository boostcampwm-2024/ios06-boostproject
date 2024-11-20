import Foundation

protocol SignAppleRepository {
    func signInApple(info: AppleAuthInfo) async throws
}
