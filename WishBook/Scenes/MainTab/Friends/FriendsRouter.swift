//
//  FriendsRouter.swift
//  WishBook
//
//  Created by Vadym on 23.03.2021.
//

import SwiftUI

protocol FriendsRouterProtocol {
    func showProfile<V: View>(userId: String?, content: () -> V) -> AnyView
}

final class FriendsRouter: FriendsRouterProtocol {
    func showProfile<V: View>(userId: String?, content: () -> V) -> AnyView {
        let userPageView = UserPageModuleBuilder.create(userId: userId)
        let navLink = NavigationLink(destination: userPageView) {
            content()
        }
        return AnyView(navLink)
    }
}
