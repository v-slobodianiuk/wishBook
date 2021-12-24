//
//  Di.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 24.12.2021.
//

import Foundation

let di: Di = Di()

struct Di {
    fileprivate let store: AppStore
    fileprivate let authState: AuthState = AuthState()
    fileprivate let profileState: ProfileState = ProfileState()
    fileprivate let wishesState: WishesState = WishesState()
    fileprivate let peopleState: PeopleState = PeopleState()
    fileprivate let googleAuthService: GoogleAuthService = GoogleAuthService()
    fileprivate let profileService: ProfileService = ProfileService()
    fileprivate let firebaseStorageService: FirebaseStorageService = FirebaseStorageService()
    fileprivate let wishListService: WishListService = WishListService()
    fileprivate let peopleService: PeopleService = PeopleService()
    
    init() {
        self.store = AppStore(
            initialState: .init(auth: authState, profile: profileState, wishes: wishesState, people: peopleState),
            reducer: appReducer,
            middlewares: [
                authMiddleware(service: googleAuthService),
                profileMiddleware(service: profileService, storageService: firebaseStorageService),
                wishesMiddleware(service: wishListService),
                peopleMiddleware(service: peopleService, profileService: profileService, wishesService: wishListService)
            ]
        )
    }
    
    func getStore() -> AppStore {
        return store
    }
}
