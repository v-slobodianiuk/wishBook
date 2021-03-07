//
//  RootCoordinator.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import UIKit
import SwiftUI
import GoogleSignIn

protocol RootCoordinatorProtocol: Coordinator {
    func showManTabView() -> AnyView
    func showLoginView() -> AnyView
}

final class RootCoordinator: RootCoordinatorProtocol {
    
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let view = RootModuleBuilder.create(with: self)
        let hosting = UIHostingController(rootView: view)
        window?.rootViewController = hosting
        GIDSignIn.sharedInstance()?.presentingViewController = window?.rootViewController
        window?.makeKeyAndVisible()
    }
    
    func showManTabView() -> AnyView {
        return AnyView(MainTabView())
    }
    func showLoginView() -> AnyView {
        return AnyView(LoginView())
    }
}
