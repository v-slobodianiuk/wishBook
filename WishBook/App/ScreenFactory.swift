//
//  ScreenFactory.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import SwiftUI


struct Di {
    private let store: AppStore
    
    init() {
        self.store =  AppStore(
            initialState: .init(auth: AuthState(), profile: ProfileState(), wishes: WishesState()),
            reducer: appReducer,
            middlewares: [authMiddleware(service: GoogleAuthService())]
        )
    }
    
    func getStore() -> AppStore {
        return store
    }
}

let screenFactory = ScreenFactory()

struct ScreenFactory {
    fileprivate let di = Di()
    
    fileprivate init() {}
    
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
    
    func makeWishListView() -> some View {
        WishListView()
            .environmentObject(di.getStore())
    }
    
    func makeProfileView() -> some View {
        NavigationView {
            ProfileView()
                .environmentObject(di.getStore())
        }
    }
}
