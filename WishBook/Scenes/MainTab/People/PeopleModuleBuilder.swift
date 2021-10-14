//
//  FriendsModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

enum PeopleModuleBuilder {
    static func create() -> some View {
        let router = PeopleRouter()
        let vm = PeopleViewModel(router: router, usersRepository: DI.getUsersRepository())
        let friendsView = PeopleView(vm: vm)
        return friendsView
    }
}
