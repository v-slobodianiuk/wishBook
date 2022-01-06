//
//  ScreenFactory.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import SwiftUI

let screenFactory: ScreenFactory = ScreenFactory()

struct ScreenFactory {
    func makeRootView() -> some View {
        RootView()
            .environmentObject(di.getStore())
    }
    
    func makeLoginView() -> some View {
        LoginView()
            .environmentObject(di.getStore())
    }
    
    func makeMainTabBar() -> some View {
        MainTabView()
            .environmentObject(di.getStore())
    }
    
    func makePeopleView() -> some View {
        PeopleView()
            .environmentObject(di.getStore())
    }
    
    func makeSearchedProfileView() -> some View {
        UserPageView()
            .environmentObject(di.getStore())
    }
    
    func makeWishListView() -> some View {
        WishListView()
            .environmentObject(di.getStore())
    }
    
    func makeWishDetailsView() -> some View {
        WishDetailsView()
            .environmentObject(di.getStore())
    }
    
    func makeProfileView() -> some View {
            ProfileView()
                .environmentObject(di.getStore())
    }
    
    func makeEditProfileView() -> some View {
        EditProfileView()
            .environmentObject(di.getStore())
    }
    
    func makeChangePasswordView() -> some View {
        ChangePasswordView()
            .environmentObject(di.getStore())
    }
}
