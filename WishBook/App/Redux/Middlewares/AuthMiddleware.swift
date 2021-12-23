//
//  AuthMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 16.12.2021.
//

import ReduxCore
import Foundation
import Combine

func authMiddleware(service: GoogleAuthServiceProtocol) -> Middleware<AppState, AppAction> {
    return { state, action in
        switch action {
            
        case .auth(action: .fetch):
            let publisher = service.checkState()
                .print("! Fetch Auth State")
                .subscribe(on: DispatchQueue.global())
                .removeDuplicates()
                .filter {$0 != UserStorage.profileUserId }
                .map { (newProfileId) -> AppAction in
                    UserStorage.profileUserId = newProfileId
                    return AppAction.auth(action: .status(isLoggedIn: !UserStorage.profileUserId.isEmpty))
                }
            
            service.startAuthListener()
            
            return publisher
                .eraseToAnyPublisher()
        case .auth(action: .status(let isLoggedIn)):
            let publisher = !isLoggedIn ? Just(AppAction.clearData).eraseToAnyPublisher() : Empty().eraseToAnyPublisher()
            return publisher
                .eraseToAnyPublisher()
        case .auth(action: .logIn(let email, let password)):
            return service.createUser(email: email, password: password)
                .print("Create User")
                .subscribe(on: DispatchQueue.global())
                .map {
                    if $0 == .new { service.addUserDataIfNeeded() }
                    return AppAction.auth(action: .fetchComplete)
                }
                .catch { error in
                    Just(AppAction.auth(action: .fetchError(error: error)))
                }
                .eraseToAnyPublisher()
            
        case .auth(action: .googleLogIn):
            service.signInUser()
        case .auth(action: .signOut):
            service.signOut()
        default:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
