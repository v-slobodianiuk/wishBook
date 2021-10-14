//
//  PeopleRouter.swift
//  WishBook
//
//  Created by Vadym on 23.03.2021.
//

import SwiftUI

protocol PeopleRouterProtocol {
    func showProfile<V: View>(userId: String?, content: () -> V) -> AnyView
}

final class PeopleRouter: PeopleRouterProtocol {
    func showProfile<V: View>(userId: String?, content: () -> V) -> AnyView {
        let userPageView = UserPageModuleBuilder.create(userId: userId)
        let navLink = NavigationLink(destination: userPageView) {
            content()
        }
        return AnyView(navLink)
    }
}
