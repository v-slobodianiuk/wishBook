//
//  ProfileRouter.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

protocol ProfileRouterProtocol {
    func goEditProfile<V: View>(profileData: ProfileModel?, content: () -> V) -> AnyView
    func showPeople<V: View>(filter: PeopleFilter, content: () -> V) -> AnyView
}

final class ProfileRouter: ProfileRouterProtocol {
    
    func goEditProfile<V: View>(profileData: ProfileModel?, content: () -> V) -> AnyView {
        let editProfileView = EditProfileModuleBuilder.create(profileData: profileData)
        let navLink = NavigationLink(destination: editProfileView) {
            content()
        }
        return AnyView(navLink)
    }
    
    func showPeople<V: View>(filter: PeopleFilter, content: () -> V) -> AnyView {
        let peopleView = PeopleModuleBuilder().create(filter: filter)
        let navLink = NavigationLink(destination: peopleView) {
            content()
        }
        return AnyView(navLink)
    }
}
