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

enum UserState {
    case new
    case existed
}

protocol GoogleAuthServiceProtocol {
    func startAuthListener()
    func checkState() -> AnyPublisher<String, Never>
    func createUser(email: String, password: String) -> AnyPublisher<UserState, Error>
    func signInUser()
    func addUserDataIfNeeded()
    func signOut()
}

final class GoogleAuthService: GoogleAuthServiceProtocol {
    
    
    private let subject = PassthroughSubject<String, Never>()
    private let db = Firestore.firestore()
    private var authListener: AuthStateDidChangeListenerHandle?
    
    func checkState() -> AnyPublisher<String, Never> {
        return subject
            .eraseToAnyPublisher()
    }
    
    func startAuthListener() {
        guard authListener == nil else { return }
        authListener = Auth.auth().addStateDidChangeListener { [weak self] (_, _) in
            self?.subject.send(Auth.auth().currentUser?.uid ?? "")
        }
    }
    
    func createUser(email: String, password: String) -> AnyPublisher<UserState, Error> {
        return Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                    if let error = error {
                        if (error as NSError).code == AuthErrorCode.emailAlreadyInUse.rawValue {
                            //promise(.success(.existed))
                            self?.loginUser(email: email, password: password)
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
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                // User existed
            }
        }
    }

    func signInUser() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        guard let rootVC = UIApplication.shared.windows.last?.rootViewController else { return }
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
                self?.addUserDataIfNeeded()
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out error: \(error.localizedDescription)")
        }
    }
    
    func addUserDataIfNeeded() {
        guard !UserStorage.profileUserId.isEmpty, let email = Auth.auth().currentUser?.email else { fatalError() }
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
}
