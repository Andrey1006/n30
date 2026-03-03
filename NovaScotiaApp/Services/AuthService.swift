import Foundation
import FirebaseAuth

enum AuthError: LocalizedError {
    case notAuthenticated
    case invalidCredentials
    case userNotFound
    case other(Error)

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User is not authenticated"
        case .invalidCredentials:
            return "Invalid email or password"
        case .userNotFound:
            return "User not found"
        case .other(let error):
            return error.localizedDescription
        }
    }
}

enum AuthResult {
    case success
    case failure(AuthError)
}

final class AuthService {
    static let shared = AuthService()

    private let auth = Auth.auth()

    private init() {}

    var currentUser: User? {
        auth.currentUser
    }

    var isAnonymous: Bool {
        currentUser?.isAnonymous ?? false
    }

    func signInAnonymously() async -> AuthResult {
        do {
            _ = try await auth.signInAnonymously()
            return .success
        } catch {
            return .failure(.other(error))
        }
    }

    func register(email: String, password: String) async -> AuthResult {
        do {
            _ = try await auth.createUser(withEmail: email, password: password)
            return .success
        } catch {
            return .failure(.other(error))
        }
    }

    func signIn(email: String, password: String) async -> AuthResult {
        do {
            _ = try await auth.signIn(withEmail: email, password: password)
            return .success
        } catch let error as NSError {
            if error.domain == AuthErrorDomain {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound, .wrongPassword, .invalidCredential:
                    return .failure(.invalidCredentials)
                default:
                    break
                }
            }
            return .failure(.other(error))
        } catch {
            return .failure(.other(error))
        }
    }

    func signOut() async -> AuthResult {
        do {
            try auth.signOut()
            return .success
        } catch {
            return .failure(.other(error))
        }
    }

    func deleteAccount() async -> AuthResult {
        guard let user = auth.currentUser else {
            return .failure(.notAuthenticated)
        }
        do {
            try await user.delete()
            return .success
        } catch {
            return .failure(.other(error))
        }
    }

    func linkAnonymousAccount(email: String, password: String) async -> AuthResult {
        guard let user = auth.currentUser, user.isAnonymous else {
            return .failure(.notAuthenticated)
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            _ = try await user.link(with: credential)
            return .success
        } catch {
            return .failure(.other(error))
        }
    }
}
