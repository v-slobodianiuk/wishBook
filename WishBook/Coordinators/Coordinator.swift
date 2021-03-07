//
//  Coordinator.swift
//  WishBook
//
//  Created by Vadym on 05.03.2021.
//

import Foundation

protocol Coordinator {
    func start()
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
