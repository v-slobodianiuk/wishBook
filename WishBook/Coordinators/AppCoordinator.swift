//
//  AppCoordinator.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    private weak var window: UIWindow?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = RootCoordinator(window: window)
        coordinate(to: coordinator)
    }
}
