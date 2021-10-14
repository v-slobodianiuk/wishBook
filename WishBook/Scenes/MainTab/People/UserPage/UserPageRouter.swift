//
//  UserPageRouter.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 14.10.2021.
//

import SwiftUI

protocol UserPageRouterProtocol: WishListRouterProtocol {
    func showPeople<V: View>(filter: PeopleFilter, content: () -> V) -> AnyView
}

final class UserPageRouter: UserPageRouterProtocol {
    func showWishDetails(wishItem: WishListModel?) -> AnyView {
        let wishDetailsView = WishDetailsModuleBuilder.create(wishItem: wishItem)
        return AnyView(wishDetailsView)
    }
    
    func showPeople<V: View>(filter: PeopleFilter, content: () -> V) -> AnyView {
        let peopleView = PeopleModuleBuilder().create(filter: filter)
        let navLink = NavigationLink(destination: peopleView) {
            content()
        }
        return AnyView(navLink)
    }
}
