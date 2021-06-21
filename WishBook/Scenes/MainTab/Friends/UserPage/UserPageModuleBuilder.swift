//
//  UserPageModuleBuilder.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import SwiftUI

enum UserPageModuleBuilder {
    static func create(userId: String?) -> some View {
        let router = WishListRouter()
        let vm = UserPageViewModel(
            router: router,
            userId: userId,
            profileRepository: DI.getProfileRepository(),
            wishListRepository: DI.getWishListRepository()
        )
        let userPageView = UserPageView(vm: vm)
        return userPageView
    }
}
