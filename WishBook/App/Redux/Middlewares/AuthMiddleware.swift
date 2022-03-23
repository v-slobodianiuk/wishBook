//
//  AuthMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 16.12.2021.
//

import ReduxCore
import Foundation
import Combine
import AuthenticationServices

func authMiddleware(service: GoogleAuthServiceProtocol) -> Middleware<AppState, AppAction> {
    return { (_: AppState, action: AppAction) -> AnyPublisher<AppAction, Never> in
        switch action {
        case .auth(action: .fetch):
            let publisher = service.checkState()
                .print("! Fetch Auth State")
                .subscribe(on: DispatchQueue.global())
                .removeDuplicates()
                .map { (newProfileId) -> AppAction in
                    UserStorage.profileUserId = newProfileId ?? ""
                    return AppAction.auth(action: .status(isLoggedIn: !UserStorage.profileUserId.isEmpty))
                }

            service.startAuthListener()

            return publisher
                .eraseToAnyPublisher()
        case .auth(action: .status(let isLoggedIn)):
            let publisher: AnyPublisher<AppAction, Never> = !isLoggedIn ? Just(AppAction.clearData).eraseToAnyPublisher() : Empty().eraseToAnyPublisher()
            return publisher
        case .auth(action: .logIn(let email, let password)):
            return service.createUser(email: email, password: password)
                .print("Create User")
                .subscribe(on: DispatchQueue.global())
                .map { (_: UserState) -> AppAction in
                    return AppAction.auth(action: .fetchComplete)
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.auth(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()

        case .auth(action: .googleLogIn):
            service.signInWithGoogle()
        case .auth(action: .sighInWithApple(let nonce, let result)):
            switch result {
            case .success(let authorization):
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    guard let appleIDToken = appleIDCredential.identityToken else {
                        print("Unable to fetch identity token")
                        return Empty().eraseToAnyPublisher()
                    }
                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return Empty().eraseToAnyPublisher()
                    }

                    service.signInWithApple(idTokenString: idTokenString, nonce: nonce, appleIDCredential: appleIDCredential)
                default: break
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        case .auth(action: .resetPassword(let email)):
            return service.resetPassword(email: email)
                .print("Reset password")
                .subscribe(on: DispatchQueue.global())
                .map { (success: Bool) -> AppAction in
                    return AppAction.auth(action: .resetPasswordComplete(success: success))
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.auth(action: .fetchError(error: error.localizedDescription)))
                }
                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .auth(action: .updatePassword(let password)):
            return service.updatePassword(password: password)
                .print("Update password")
                .subscribe(on: DispatchQueue.global())
                .map { (isChanged: Bool) -> AppAction in
                    return AppAction.auth(action: .updatePasswordComplete(isChanged: isChanged))
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.auth(action: .fetchError(error: error.localizedDescription)))
                }
                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .auth(action: .signOut):
            service.signOut()
        case .clearData:
            return Just(AppAction.profile(action: .removeListeners)).eraseToAnyPublisher()
        default:
            break
        }

        return Empty().eraseToAnyPublisher()
    }
}
