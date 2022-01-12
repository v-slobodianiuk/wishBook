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
        if let filePath = Bundle.main.path(forResource: Globals.googleServiceResource, ofType: "plist"), let options = FirebaseOptions(contentsOfFile: filePath) {
            FirebaseApp.configure(options: options)
        } else {
            FirebaseApp.configure()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
