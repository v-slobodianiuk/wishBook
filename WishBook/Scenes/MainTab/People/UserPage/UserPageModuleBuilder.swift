//
//  UserPageModuleBuilder.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import SwiftUI

enum UserPageModuleBuilder {
    static func create(profileUserId: String?) -> some View {
        let router = UserPageRouter()
        let vm = UserPageViewModel(
            router: router,
            profileUserId: profileUserId,
            profileRepository: DI.getProfileRepository(),
            wishListRepository: DI.getWishListRepository(),
            usersRepository: DI.getUsersRepository()
        )
        let userPageView = UserPageView(vm: vm)
        return userPageView
    }
}
