//
//  GoogleAuthentificationService.swift
//  WishBook
//
//  Created by Vadym on 17.03.2021.
//

import Foundation
import Firebase
import GoogleSignIn

//enum GoogleAuthError: Error {
//    case badURL
//}

enum UserState {
    case new
    case existed
}

typealias AuthResult = (Result<UserState, Error>) -> Void

protocol GoogleAuthServiceProtocol: AnyObject {
    func createUser(email: String, password: String, completion: @escaping AuthResult)
    func loginUser(email: String, password: String, completion: @escaping AuthResult)
    func signInUser(completion: @escaping () -> Void)
}

final class GoogleAuthService: NSObject, GoogleAuthServiceProtocol {
    
    func createUser(email: String, password: String, completion: @escaping AuthResult) {
        Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
            if let error = error {
                if (error as NSError).code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.loginUser(email: email, password: password, completion: completion)
                } else {
                    completion(.failure(error))
                }
                return
            } else {
                completion(.success(.new))
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping AuthResult) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            } else {
                completion(.success(.existed))
            }
        }
    }

    func signInUser(completion: @escaping () -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        guard let rootVC = UIApplication.shared.windows.last?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootVC) { user, error in

          if let error = error {
            print("Google SignIn error: \(error.localizedDescription)")
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

            let credentials = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credentials) { (result, error) in
                guard error == nil else {
                    print("Google SignIn error: \(error?.localizedDescription ?? "Unknown")")
                    return
                }
                completion()
            }
        }
    }
}
