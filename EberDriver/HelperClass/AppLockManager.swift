
import Foundation
import UIKit
import LocalAuthentication

class AppLockManager {
    static let shared = AppLockManager()
    
    private init() {} // Ensure it's a singleton
    
    func BiometricAuth(completion: @escaping (AuthenticationResult) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Please verify yourself.") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Passcode authentication successful
                        completion(.success)
                    } else {
                        // Passcode authentication failed or was canceled
                        print(authenticationError?.localizedDescription)
                        completion(.failure)
                    }
                }
            }
        } else {
            // Passcode authentication is not available or an error occurred
            completion(.failure)
        }
    }
    
    func handleAuthenticationError(_ authenticationError: Error, completion: @escaping (AuthenticationResult) -> Void) {
        if let laError = authenticationError as? LAError {
            switch laError.code {
                
            case .authenticationFailed:
                print("authentication failed")
                completion(.failure)

            case .userCancel:
                print("user denied to identify.")
                completion(.failure)
                
            case .userFallback:
                print("fallback")
                self.BiometricAuth(completion: completion)
                
            case .biometryLockout:
                print("lock out due to many failed attempts")
                self.BiometricAuth(completion: completion)

            default:
                print(laError.localizedDescription)
                completion(.failure)
            }
        }
    }
}

enum AuthenticationResult {
    case success
    case failure
}
