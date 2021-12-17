//
//  AuthMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 16.12.2021.
//

import Combine
import ReduxCore
import Foundation

func authMiddleware(service: GoogleAuthServiceProtocol) -> Middleware<AppState, AppAction> {
    return { state, action in
        switch action {
            
        case .auth(action: .fetch):
            let publisher = service.checkState()
                .print("! Fetch Auth State")
                //.subscribe(on: DispatchQueue.main)
                .flatMap({ (isLoggedIn) -> Just<AppAction> in
                    //myNotification.
                    print("Get new value: \(isLoggedIn)")
                    return Just(AppAction.auth(action: .status(isLoggedIn: isLoggedIn)))
                })
            
            service.startAuthListener()
            
            return publisher
                .eraseToAnyPublisher()
        case .auth(action: .logIn(let email, let password)):
            return service.createUser(email: email, password: password)
                .print("Create User")
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
