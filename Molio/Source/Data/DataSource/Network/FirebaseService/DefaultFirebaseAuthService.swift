import FirebaseAuth

struct DefaultFirebaseAuthService: AuthService {
    
    func getCurrentUser() throws -> User {
        guard let currentUser = Auth.auth().currentUser else {
            throw FirebaseAuthError.userNotFound
        }
        return currentUser
    }
    
    func getCurrentID() throws -> String {
        return try getCurrentUser().uid
    }
    
    func signInApple(info: AppleAuthInfo) async throws {
        let credential = OAuthProvider.appleCredential(
            withIDToken: info.idToken,
            rawNonce: info.nonce,
            fullName: info.fullName
        )
        do {
            try await Auth.auth().signIn(with: credential)
        } catch {
            throw FirebaseAuthError.loginFailed
        }
    }
    
    func logout() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw FirebaseAuthError.logoutFailed
        }
    }
    
    func reauthenticateApple(idToken: String, nonce: String) async throws {
        guard Auth.auth().currentUser != nil else {
            throw FirebaseAuthError.userNotFound
        }
        let credential = OAuthProvider.credential(
            providerID: .apple,
            idToken: idToken,
            rawNonce: nonce
        )
        do {
            try await getCurrentUser().reauthenticate(with: credential)
        } catch {
            throw FirebaseAuthError.reauthenticateFailed
        }
    }
    
    func deleteAccount(authorizationCode: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw FirebaseAuthError.userNotFound
        }
        do {
            try await Auth.auth().revokeToken(withAuthorizationCode: authorizationCode)
            try await currentUser.delete()
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                throw FirebaseAuthError.requiresReauthentication
            } else {
                throw FirebaseAuthError.deleteAccountFailed
            }
        }
    }
    
}
