//
//  AuthAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

enum AuthAction {
    case fetch
    case fetchComplete
    case status(isLoggedIn: Bool)
    case logIn(login: String, password: String)
    case googleLogIn
    case resetPassword(email: String)
    case updatePassword(password: String)
    case updatePasswordComplete(isChanged: Bool)
    case resetPasswordComplete(success: Bool)
    
    case signOut
    case fetchError(error: String?)
}
