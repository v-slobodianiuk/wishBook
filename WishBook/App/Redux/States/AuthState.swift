//
//  AuthState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation
import SwiftUI
import Firebase

struct AuthState {
    var fetchInProgress: Bool = false
    var isLoggedIn: Bool = UserStorage.isLoggedIn
    var login: String = ""
    var password: String = ""
    var errorMessage: String?
}
