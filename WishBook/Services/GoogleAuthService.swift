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

protocol GoogleAuthServiceProtocol: class {
    var googleSignIn: (() -> Void)? { get set }
    func createUser(email: String, password: String, completion: @escaping AuthResult)
    func loginUser(email: String, password: String, completion: @escaping AuthResult)
}

final class GoogleAuthService: NSObject, GoogleAuthServiceProtocol {
    
    var googleSignIn: (() -> Void)?
    
    override init() {
        super.init()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
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
}

extension GoogleAuthService: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            print("Google SignIn error: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken,
            accessToken: authentication.accessToken
        )

        Auth.auth().signIn(with: credential) { [self] (result, error) in
            guard error == nil else {
                print("Google SignIn error: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            googleSignIn?()
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
