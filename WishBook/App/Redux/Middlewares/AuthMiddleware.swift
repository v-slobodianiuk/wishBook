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
    return { (state: AppState, action: AppAction) -> AnyPublisher<AppAction, Never> in
        switch action {
        case .auth(action: .fetch):
            let publisher = service.checkState()
                .print("! Fetch Auth State")
                .subscribe(on: DispatchQueue.global())
                .removeDuplicates()
                .filter { (newProfileId) -> Bool in
                    return newProfileId != UserStorage.profileUserId
                }
                .map { (newProfileId) -> AppAction in
                    UserStorage.profileUserId = newProfileId
                    return AppAction.auth(action: .status(isLoggedIn: !UserStorage.profileUserId.isEmpty))
                }
            
            service.startAuthListener()
            
            return publisher
                .eraseToAnyPublisher()
        case .auth(action: .status(let isLoggedIn)):
            let publisher: AnyPublisher<AppAction, Never> = !isLoggedIn ? Just(AppAction.clearData).eraseToAnyPublisher() : Empty().eraseToAnyPublisher()
            return publisher
                .eraseToAnyPublisher()
        case .auth(action: .logIn(let email, let password)):
            return service.createUser(email: email, password: password)
                .print("Create User")
                .subscribe(on: DispatchQueue.global())
                .map { (state: UserState) -> AppAction in
                    if state == .new { service.addUserDataIfNeeded() }
                    return AppAction.auth(action: .fetchComplete)
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.auth(action: .fetchError(error: error)))
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
