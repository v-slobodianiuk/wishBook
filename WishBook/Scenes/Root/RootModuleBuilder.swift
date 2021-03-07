//
//  RootModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

enum RootModuleBuilder {
    static func create(with coordinator: RootCoordinatorProtocol) -> some View {
        let view = RootView(coordinator: coordinator)
        return view
    }
}
