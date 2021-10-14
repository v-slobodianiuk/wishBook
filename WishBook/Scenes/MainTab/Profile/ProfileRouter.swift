//
//  ProfileRouter.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

protocol ProfileRouterProtocol: UserPageRouterProtocol {
    func goEditProfile<V: View>(profileData: ProfileModel?, content: () -> V) -> AnyView
}

final class ProfileRouter: ProfileRouterProtocol {
    
    func goEditProfile<V: View>(profileData: ProfileModel?, content: () -> V) -> AnyView {
        let editProfileView = EditProfileModuleBuilder.create(profileData: profileData)
        let navLink = NavigationLink(destination: editProfileView) {
            content()
        }
        return AnyView(navLink)
    }
}
