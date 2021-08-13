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
        window?.makeKeyAndVisible()
    }
    
    func showManTabView() -> AnyView {
        let tabCoordinator = MainTabCoordinator()
        let mainTabView = MainTabView(coordinator: tabCoordinator)
        return AnyView(mainTabView)
    }
    func showLoginView() -> AnyView {
        let loginView = LoginModuleBuilder.create()
        return AnyView(loginView)
    }
}
