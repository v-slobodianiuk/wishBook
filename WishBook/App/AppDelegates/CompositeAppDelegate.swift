//
//  CompositeAppDelegate.swift
//  WishBook
//
//  Created by Vadym on 06.03.2021.
//

import UIKit

typealias AppDelegateType = UIResponder & UIApplicationDelegate

final class CompositeAppDelegate: AppDelegateType {
    private let appDelegates: [AppDelegateType]

    init(appDelegates: [AppDelegateType]) {
        self.appDelegates = appDelegates
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appDelegates.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        appDelegates.forEach { _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        appDelegates.forEach { _ = $0.application?(app, open: url, options: options) }
        return true
    }
}
