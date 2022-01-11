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

typealias SignInWithAppleResult = (authDataResult: AuthDataResult, appleIDCredential: ASAuthorizationAppleIDCredential)

// MARK: - SignIn with Apple Erors
enum SignInWithAppleAuthError: Error {
    case noAuthDataResult
    case noIdentityToken
    case noIdTokenString
    case noAppleIDCredential
}

enum UserState {
    case new
    case existed
}

protocol GoogleAuthServiceProtocol {
    func startAuthListener()
    func checkState() -> AnyPublisher<String?, Never>
    func createUser(email: String, password: String) -> AnyPublisher<UserState, Error>
    func signInUser()
    func signInWithApple(idTokenString: String, nonce: String, appleIDCredential: ASAuthorizationAppleIDCredential)
    func addUserDataIfNeeded(email: String)
    func signOut()
    
    func updatePassword(password: String) -> AnyPublisher<Bool, Error>
    func resetPassword(email: String) -> AnyPublisher<Bool, Error>
}

final class GoogleAuthService: GoogleAuthServiceProtocol {
    
    
    private let subject = PassthroughSubject<String?, Never>()
    private let db = Firestore.firestore()
    private var authListener: AuthStateDidChangeListenerHandle?
    
    func checkState() -> AnyPublisher<String?, Never> {
        return subject
            .eraseToAnyPublisher()
    }
    
    //MARK: - Auth State Listener
    func startAuthListener() {
        guard authListener == nil else { return }
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, _) in
            self?.subject.send(auth.currentUser?.uid)
        }
    }
    
    //MARK: - Create user
    func createUser(email: String, password: String) -> AnyPublisher<UserState, Error> {
        return Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    if let error = error {
                        if (error as NSError).code == AuthErrorCode.emailAlreadyInUse.rawValue {
                            //promise(.success(.existed))
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
                    } else {
                        promise(.success(.new))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    //MARK: - Sign In
    private func loginUser(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(error)
        }
    }

    //MARK: - Sign In with Google
    func signInUser() {
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
                if let email = result?.user.email {
                    self?.addUserDataIfNeeded(email: email)
                }
            }
        }
    }
    
    // MARK: - SignIn with Apple Functions
    func signInWithApple(idTokenString: String, nonce: String, appleIDCredential: ASAuthorizationAppleIDCredential) {
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        // Sign in with Apple.
        Auth.auth().signIn(with: credential) { [weak self] (authDataResult, err) in
            if let err = err {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(err.localizedDescription)
                return
            }
            // User is signed in to Firebase with Apple.
            guard let authDataResult = authDataResult else {
                //completion(.failure(SignInWithAppleAuthError.noAuthDataResult))
                return
            }
            
            let signInWithAppleRestult = (authDataResult,appleIDCredential)
            self?.handle(signInWithAppleRestult)
        }
    }
    
    private func handle(_ signInWithAppleResult: SignInWithAppleResult) {
        // SignInWithAppleResult is a tuple with the authDataResult and appleIDCredentioal
        // Now that you are signed in, we can update our User database to add this user.
        
        // First the uid
        //let uid = signInWithAppleResult.authDataResult.user.uid
        
        //let fullName = signInWithAppleResult.appleIDCredential.fullName
        
        // Extract all three components
        //let firstName = fullName?.givenName ?? ""
        //let lastName = fullName?.familyName ?? ""
        
        let email = signInWithAppleResult.authDataResult.user.email ?? ""
        
        //TODO: - Save user Data
        addUserDataIfNeeded(email: email)
    }
    
    //MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Add User data to Datebase
    func addUserDataIfNeeded(email: String) {
        guard !UserStorage.profileUserId.isEmpty else { return }
        print("user id: \(UserStorage.profileUserId), \(email)")
        let userDoc = db.collection(FirestoreCollection[.users]).document(UserStorage.profileUserId)
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("LoadData error: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, !document.exists else { return }
            let confiredData = ProfileModel(id: UserStorage.profileUserId, email: email)
            do {
                try userDoc.setData(from: confiredData)
            } catch {
                print("updateData error: \(error.localizedDescription)")
            }
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
