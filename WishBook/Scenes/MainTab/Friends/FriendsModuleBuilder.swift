//
//  FriendsModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

enum FriendsModuleBuilder {
    static func create() -> some View {
        let router = FriendsRouter()
        let vm = FriendsViewModel(router: router, usersRepository: DI.getUsersRepository())
        let friendsView = FriendsView(vm: vm)
        return friendsView
    }
}
