//
//  AuthReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

func authReducer(state: inout AuthState, action: AuthAction) -> Void {
    switch action {
    case .fetch:
        state.fetchInProgress = true
    case .status(let isLoggedIn):
        UserStorage.isLoggedIn = isLoggedIn
        state.isLoggedIn = UserStorage.isLoggedIn
        state.fetchInProgress = false
    case .logIn(let login, let password):
        state.fetchInProgress = true
        state.login = login
        state.password = password
    case .googleLogIn:
        break
    case .signOut:
        break
    case .fetchError(error: let error):
        print(error?.localizedDescription ?? "")
        break
    case .fetchComplete:
        state.fetchInProgress = false
    }
}
