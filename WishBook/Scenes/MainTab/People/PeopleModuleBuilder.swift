//
//  FriendsModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct PeopleModuleBuilder {
    func create(filter: PeopleFilter? = nil) -> some View {
        let router = PeopleRouter()
        let vm = PeopleViewModel(router: router, usersRepository: DI.getUsersRepository())
        vm.filter = filter
        let friendsView = PeopleView()
        return friendsView
    }
}
