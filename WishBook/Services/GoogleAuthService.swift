//
//  GoogleAuthentificationService.swift
//  WishBook
//
//  Created by Vadym on 17.03.2021.
//

import Foundation
import Combine
import Firebase
import GoogleSignIn
import AuthenticationServices

enum UserState {
    case new
    case existed
}

protocol GoogleAuthServiceProtocol {
    func startAuthListener()
    func checkState() -> AnyPublisher<String?, Never>
    func createUser(email: String, password: String) -> AnyPublisher<UserState, Error>
    func signInWithGoogle()
    func signInWithApple(idTokenString: String, nonce: String, appleIDCredential: ASAuthorizationAppleIDCredential)
    func signOut()
    
    func updatePassword(password: String) -> AnyPublisher<Bool, Error>
    func resetPassword(email: String) -> AnyPublisher<Bool, Error>
}

final class GoogleAuthService: GoogleAuthServiceProtocol {
    
    
    private let subject = PassthroughSubject<String?, Never>()
    private let db = Firestore.firestore()
    private var authListener: AuthStateDidChangeListenerHandle?
    
    //MARK: - Sign In
    private func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }
    
    //MARK: - Auth State Listener
    func startAuthListener() {
        guard authListener == nil else { return }
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, _) in
            self?.subject.send(auth.currentUser?.uid)
        }
    }
    
    func checkState() -> AnyPublisher<String?, Never> {
        return subject
            .eraseToAnyPublisher()
    }
    
    //MARK: - Create user
    func createUser(email: String, password: String) -> AnyPublisher<UserState, Error> {
        return Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    
                    if let error = error {
                        if (error as NSError).code == AuthErrorCode.emailAlreadyInUse.rawValue {
                            self?.loginUser(email: email, password: password) { error in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(.existed))
                                }
                            }
                        } else {
                            promise(.failure(error))
                        }
                        return
                    }
                    
                    promise(.success(.new))
                    guard let userId = authResult?.user.uid else { return }
                    var profile = ProfileModel()
                    profile.id = userId
                    profile.email = authResult?.user.email
                    
                    self?.addUserDataIfNeeded(profile: profile)
                }
            }
        }.eraseToAnyPublisher()
    }

    //MARK: - Sign In with Google
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootVC) { [weak self] user, error in
            
            if let error = error {
                print("Google SignIn error: \(error.localizedDescription)")
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else { return }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken,
                                                            accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credentials) { (result, error) in
                guard error == nil else {
                    print("Google SignIn error: \(error?.localizedDescription ?? "Unknown")")
                    return
                }
                
                guard let userId = result?.user.uid else { return }
                var profile = ProfileModel()
                profile.id = userId
                profile.email = result?.user.email
                profile.photoUrl = result?.user.photoURL?.absoluteString
                
                self?.addUserDataIfNeeded(profile: profile)
            }
        }
    }
    
    // MARK: - Sign in with Apple
    func signInWithApple(idTokenString: String, nonce: String, appleIDCredential: ASAuthorizationAppleIDCredential) {
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: credential) { [weak self] (authDataResult, error) in
            if let error = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure you're sending the SHA256-hashed nonce as a hex string with your request to Apple.
                print(error.localizedDescription)
                return
            }
            // User is signed in to Firebase with Apple.
            guard let authDataResult = authDataResult else {
                print("Apple Sign in error: No Auth Data Result!")
                return
            }
            
            var profile = ProfileModel()
            profile.id = authDataResult.user.uid
            profile.email = authDataResult.user.email
            profile.firstName = appleIDCredential.fullName?.givenName
            profile.photoUrl = authDataResult.user.photoURL?.absoluteString
            
            if let lastName = appleIDCredential.fullName?.familyName {
                profile.lastName = lastName
                profile.searchKey = lastName.prefix(3).lowercased()
            }
            
            self?.addUserDataIfNeeded(profile: profile)
        }
    }
    
    //MARK: - Add User data to DB
    func addUserDataIfNeeded(profile: ProfileModel) {
        let userDoc = db
            .collection(Globals.usersCollectionName)
            .document(UserStorage.profileUserId)
        
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("LoadData error: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, !document.exists else { return }

            do {
                try userDoc.setData(from: profile)
            } catch {
                print("UpdateData error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Reset Password
    func resetPassword(email: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { promise in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    //MARK: - Update Password
    func updatePassword(password: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { promise in
                Auth.auth().currentUser?.updatePassword(to: password) { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
}
