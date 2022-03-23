//
//  AuthReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

func authReducer(state: inout AuthState, action: AuthAction) {
    switch action {
    case .fetch:
        state.fetchInProgress = true
    case .status(let isLoggedIn):
        UserStorage.isLoggedIn = isLoggedIn
        state.isLoggedIn = UserStorage.isLoggedIn
        state.login.removeAll()
        state.password.removeAll()
        state.errorMessage = nil
        state.fetchInProgress = false
    case .logIn(let login, let password):
        state.fetchInProgress = true
        state.login = login
        state.password = password
    case .googleLogIn, .sighInWithApple, .signOut:
        break
    case .fetchError(error: let error):
        state.fetchInProgress = false
        state.errorMessage = error
    case .fetchComplete:
        state.fetchInProgress = false
    case .resetPassword(email: _):
        state.fetchInProgress = true
    case .updatePassword(password: _):
        state.fetchInProgress = true
    case .updatePasswordComplete(isChanged: let isChanged):
        state.fetchInProgress = false
        state.successfullyPaswordChanged = isChanged
    case .resetPasswordComplete(let success):
        state.fetchInProgress = false
        state.successfullyPaswordReset = success
    }
}
