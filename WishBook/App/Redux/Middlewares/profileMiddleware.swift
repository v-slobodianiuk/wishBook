//
//  profileMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 17.12.2021.
//

import Foundation
import Combine
import ReduxCore

func profileMiddleware(service: ProfileServiceProtocol, storageService: FirebaseStorageServiceProtocol) -> Middleware<AppState, AppAction> {
    return { state, action in
        switch action {
        case .profile(action: .fetch):
            guard state.profile.profileData == nil else {
                return Empty().eraseToAnyPublisher()
            }
            
            return service.loadDataByUserId(nil)
                .print("Fetch profile data")
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.global())
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
                .mapError { error -> ProfileServiceError in
                    return .unknown(message: error.localizedDescription)
                }
                .flatMap { url -> AnyPublisher<ProfileModel, ProfileServiceError> in
                    var profileData = state.profile.profileData ?? ProfileModel()
                    profileData.photoUrl = url?.absoluteString
                    return service.updateData(profileData)
                        .print("Update Profile Data")
                        .eraseToAnyPublisher()
                }
                .map { updatedData -> AppAction in
                    return AppAction.profile(action: .profileUpdated(data: updatedData))
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
                .print("Update Profile Data")
                .map { updatedData -> AppAction in
                    return AppAction.profile(action: .profileUpdated(data: updatedData))
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
        default:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
