import FirebaseAuth

struct DefaultFirebaseService: FirebaseService {
    func signInApple(info: AppleAuthInfo) async throws {
        let credential = OAuthProvider.appleCredential(
            withIDToken: info.idToken,
            rawNonce: info.nonce,
            fullName: info.fullName
        )
        
        do {
            try await Auth.auth().signIn(with: credential)
        } catch {
            throw FirebaseError.loginFail
        }
    }
}
