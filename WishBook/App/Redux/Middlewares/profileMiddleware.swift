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
    return { (state: AppState, action: AppAction) -> AnyPublisher<AppAction, Never> in
        switch action {
        case .profile(action: .fetch):
            guard !service.profileDataListenerIsActive() else {
                return Empty().eraseToAnyPublisher()
            }
            
            let publisher: AnyPublisher<AppAction, Never> = service.profileDataPublisher()
                .print("Fetch profile data")
                .subscribe(on: DispatchQueue.global())
                //.removeDuplicates()
                .map { (data: ProfileModel) -> AppAction in
                    return AppAction.profile(action: .fetchComplete(data: data))
                }
                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
            
            service.startProfileDataListener()
            
            return publisher
//            return service.loadDataByUserId(nil)
//                .print("Fetch profile data")
//                .subscribe(on: DispatchQueue.global())
//                .map { (data: ProfileModel) -> AppAction in
//                    return AppAction.profile(action: .fetchComplete(data: data))
//                }
//                .catch { (error: ProfileServiceError) -> Just<AppAction> in
//                    switch error {
//                    case .userIdNotFound:
//                        return Just(AppAction.profile(action: .fetchError(error: "SignOut needed!")))
//                    case .notFound:
//                        return Just(AppAction.profile(action: .fetchError(error: "Oops! Not found =(")))
//                    case .unknown(let message):
//                        return Just(AppAction.profile(action: .fetchError(error: message)))
//                    }
//                }
//                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
//                .eraseToAnyPublisher()
            
        case .profile(action: .uploadProfilePhoto(data: let data)):
            guard let userId = state.profile.profileData?.id else {
                return Empty().eraseToAnyPublisher()
            }
            
            return storageService.upload(imageData: data, userId: userId)
                .print("Upload photo")
                .subscribe(on: DispatchQueue.global())
                .mapError { (error: Error) -> ProfileServiceError in
                    return .unknown(message: error.localizedDescription)
                }
                .compactMap { (url: URL?) -> String? in
                    return url?.absoluteString
                }
                .flatMap { (urlString: String) -> AnyPublisher<Bool, Never> in
                    return service.updateDataBy(key: .photoUrl, value: urlString)
                        .print("Update photo url in profile")
                        .eraseToAnyPublisher()
                }
                .map { (_) -> AppAction in
                    return AppAction.profile(action: .updatedCompleted)
                }
                .catch { (error: ProfileServiceError) -> Just<AppAction> in
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
                .map { (_) -> AppAction in
                    return AppAction.profile(action: .updatedCompleted)
                }
                .catch { (error: ProfileServiceError) -> Just<AppAction> in
                    switch error {
                    case .unknown(let message):
                        return Just(AppAction.profile(action: .fetchError(error: message)))
                    default:
                        return Just(AppAction.profile(action: .fetchError(error: "")))
                    }
                }
                .eraseToAnyPublisher()
        case .profile(action: .fetchComplete):
            guard !service.wishCounterListenerIsActive() else {
                return Empty().eraseToAnyPublisher()
            }
            
            return Just(AppAction.profile(action: .checkWishesCount))
                .eraseToAnyPublisher()
        case .profile(action: .checkWishesCount):
            let publisher: AnyPublisher<AppAction, Never> = service.wishesCountPublisher()
                .print("Wishes count publisher")
                .subscribe(on: DispatchQueue.global())
                .removeDuplicates()
                .filter { (wishes: Int) -> Bool in
                    return wishes != state.profile.profileData?.wishes
                }
                .flatMap { (wishes: Int) -> AnyPublisher<Bool, Never> in
                    return service.updateDataBy(key: .wishesCount, value: wishes)
                        .print("Update wishes count in profile")
                        .eraseToAnyPublisher()
                }
                .filter { (isUpdated: Bool) -> Bool in
                    return isUpdated
                }
                .map { (_) -> AppAction in
                    return AppAction.profile(action: .updatedCompleted)
                }
                .eraseToAnyPublisher()
            
            service.startWishesListener()
            
            return publisher
        default:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
