//
//  profileMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 17.12.2021.
//

import ReduxCore
import Foundation
import Combine

func profileMiddleware(service: ProfileServiceProtocol, storageService: FirebaseStorageServiceProtocol) -> Middleware<AppState, AppAction> {
    return { state, action in
        switch action {
        case .profile(action: .fetch(let force)):
            guard state.profile.profileData == nil || force else {
                return Empty().eraseToAnyPublisher()
            }
            
            return service.loadDataByUserId(nil)
                .print("Fetch profile data")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .map {
                    return AppAction.profile(action: .fetchComplete(data: $0))
                }
                .catch { (error: ProfileServiceError) -> Just<AppAction> in
                    switch error {
                    case .userIdNotFound:
                        return Just(AppAction.profile(action: .fetchError(error: "SignOut needed!")))
                    case .notFound:
                        return Just(AppAction.profile(action: .fetchError(error: "Oops! Not found =(")))
                    case .unknown(let message):
                        return Just(AppAction.profile(action: .fetchError(error: message)))
                    }
                }
                .eraseToAnyPublisher()
        case .profile(action: .uploadProfilePhoto(data: let data)):
            guard let userId = state.profile.profileData?.id else {
                return Empty().eraseToAnyPublisher()
            }
            
            return storageService.upload(imageData: data, userId: userId)
                .print("Upload photo")
                .subscribe(on: DispatchQueue.global())
                .mapError { error -> ProfileServiceError in
                    return .unknown(message: error.localizedDescription)
                }
                .compactMap {
                    $0?.absoluteString
                }
                .flatMap { urlString -> AnyPublisher<Bool, Never> in
                    return service.updateDataBy(key: .photoUrl, value: urlString)
                        .print("Update photo url in profile")
                        .eraseToAnyPublisher()
                }
                .map { _ in
                    return AppAction.profile(action: .fetch(force: true))
                }
                .catch { (error) -> Just<AppAction> in
                    switch error {
                    case .unknown(let message):
                        return Just(AppAction.profile(action: .fetchError(error: message)))
                    default:
                        return Just(AppAction.profile(action: .fetchError(error: "")))
                    }
                }
                .eraseToAnyPublisher()
        case .profile(action: .updateProfileData(let firstName, let lastName, let description, let email, let birthDate)):
            guard let profileData = state.profile.profileData else {
                return Empty().eraseToAnyPublisher()
            }
            
            var checkData = profileData
            checkData.firstName = firstName
            checkData.lastName = lastName
            checkData.description = description
            checkData.email = email
            checkData.birthdate = birthDate
            
            guard profileData != checkData else {
                return Empty().eraseToAnyPublisher()
            }
            return service.updateData(checkData)
                .print("Update profile data")
                .subscribe(on: DispatchQueue.global())
                .map { _ in
                    return AppAction.profile(action: .fetch(force: true))
                }
                .catch { (error) -> Just<AppAction> in
                    switch error {
                    case .unknown(let message):
                        return Just(AppAction.profile(action: .fetchError(error: message)))
                    default:
                        return Just(AppAction.profile(action: .fetchError(error: "")))
                    }
                }
                .eraseToAnyPublisher()
        case .profile(action: .fetchComplete):
            let publisher = Just(AppAction.profile(action: .checkWishesCount))
                .eraseToAnyPublisher()
            return service.wishCounterListener == nil ? publisher : Empty().eraseToAnyPublisher()
        case .profile(action: .checkWishesCount):
            
            let publisher = service.wishesCountPublisher()
            
            if service.wishCounterListener == nil {
                service.startWishesListener()
            }
            
            return publisher
                .print("Wishes count publisher")
                .subscribe(on: DispatchQueue.global())
                .filter {
                    $0 != state.profile.profileData?.wishes
                }
                .flatMap { wishes -> AnyPublisher<Bool, Never> in
                    return service.updateDataBy(key: .wishesCount, value: wishes)
                        .print("Update wishes count in profile")
                        .eraseToAnyPublisher()
                }
                .filter {
                    return $0
                }
                .map { _ in
                    AppAction.profile(action: .fetch(force: true))
                }
                .eraseToAnyPublisher()
        default:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
