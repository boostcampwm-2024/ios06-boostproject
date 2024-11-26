import FirebaseAuth

struct DefaultFirebaseAuthService: AuthService {
    
    func getCurrentUser() throws -> User {
        guard let currentUser = Auth.auth().currentUser else {
            throw FirebaseAuthError.userNotFound
        }
        return currentUser
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
    
    func deleteAccount() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw FirebaseAuthError.userNotFound
        }
        
        do {
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
