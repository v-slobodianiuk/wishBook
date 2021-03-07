//
//  GoogleAppDelegate.swift
//  WishBook
//
//  Created by Vadym on 06.03.2021.
//

import UIKit
import Firebase
import GoogleSignIn

final class GoogleAppDelegate: AppDelegateType {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
}

extension GoogleAppDelegate: GIDSignInDelegate {
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
        // ...
        Auth.auth().signIn(with: credential) { (result, error) in
            guard error == nil else {
                print("Google SignIn error: \(error?.localizedDescription ?? "Unknown")")
                return
            }
            UserStorage.isLoggedIn = true
//            print("Success")
//            print("Name: \(result?.user.displayName ?? "")")
//            print("email: \(result?.user.email ?? "")")
//            print("isEmailVerified: \(result?.user.isEmailVerified ?? false)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
            // ...
    }
}
