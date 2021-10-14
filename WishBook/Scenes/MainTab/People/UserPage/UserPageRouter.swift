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

extension UserPageRouterProtocol {
    func showPeople<V: View>(filter: PeopleFilter, content: () -> V) -> AnyView {
        let peopleView = PeopleModuleBuilder().create(filter: filter)
        let navLink = NavigationLink(destination: peopleView) {
            content()
        }
        return AnyView(navLink)
    }
}

final class UserPageRouter: UserPageRouterProtocol {

}
