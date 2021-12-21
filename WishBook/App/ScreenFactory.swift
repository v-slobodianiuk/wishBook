//
//  ScreenFactory.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import SwiftUI


struct Di {
    fileprivate let store: AppStore
    
    fileprivate var authState = AuthState()
    fileprivate var profileState = ProfileState()
    fileprivate var wishesState = WishesState()
    fileprivate var googleAuthService = GoogleAuthService()
    fileprivate var profileService = ProfileService()
    fileprivate var firebaseStorageService = FirebaseStorageService()
    fileprivate var wishListService = WishListService()
    
    init() {
        self.store =  AppStore(
            initialState: .init(auth: authState, profile: profileState, wishes: wishesState),
            reducer: appReducer,
            middlewares: [
                authMiddleware(service: googleAuthService),
                profileMiddleware(service: profileService, storageService: firebaseStorageService),
                wishesMiddleware(service: wishListService)
            ]
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
    
    func makeWishDetailsView(isEditable: Bool) -> some View {
        WishDetailsView(isEditable: isEditable)
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
}
