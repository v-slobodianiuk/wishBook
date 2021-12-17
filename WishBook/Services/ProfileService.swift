//
//  ProfileService.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 17.12.2021.
//

import Foundation
import Combine
import Firebase

enum ProfileServiceError: Error {
    case userIdNotFound
    case notFound
    case unknown(message: String)
}

protocol ProfileServiceProtocol {
    func loadDataByUserId(_ userId: String?) -> AnyPublisher<ProfileModel, ProfileServiceError>
    func updateData(_ data: ProfileModel) -> AnyPublisher<ProfileModel, ProfileServiceError>
}

extension ProfileServiceProtocol {
//    func loadDataByUserId(_ userId: String? = nil) -> AnyPublisher<ProfileModel, ProfileServiceError> {
//        return Empty().eraseToAnyPublisher()
//    }
}

final class ProfileService: ProfileServiceProtocol {
    private let db = Firestore.firestore()
    lazy var profileUserId = Auth.auth().currentUser?.uid
    
    func loadDataByUserId(_ userId: String?) -> AnyPublisher<ProfileModel, ProfileServiceError> {
        Deferred {
            Future { [weak self] promise in
                var id: String
                if let userId = userId {
                    id = userId
                } else if let profileUserId = self?.profileUserId {
                    id = profileUserId
                } else {
                    promise(.failure(.userIdNotFound))
                    return
                }
                
                self?.db.collection(FirestoreCollection[.users])
                    .document(id)
                    .getDocument { (document, error) in
                        let result = Result {
                            try document?.data(as: ProfileModel.self)
                        }
                        
                        switch result {
                        case .success(let document):
                            guard let profile = document else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                promise(.failure(.notFound))
                                return
                            }
                            
                            // Data value was successfully initialized from the DocumentSnapshot.
                            promise(.success(profile))
                        case .failure(let error):
                            // Data value could not be initialized from the DocumentSnapshot.
                            promise(.failure(.unknown(message: error.localizedDescription)))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateData(_ data: ProfileModel) -> AnyPublisher<ProfileModel, ProfileServiceError> {
        Deferred {
            Future { [weak self] promise in
                guard let userId = self?.profileUserId else {
                    promise(.failure(.userIdNotFound))
                    return
                }
                var confiredData = data
                confiredData.id = userId
                do {
                    try self?.db.collection(FirestoreCollection[.users])
                        .document(userId)
                        .setData(from: confiredData)
                    promise(.success(data))
                } catch {
                    promise(.failure(.unknown(message: error.localizedDescription)))
                }
            }
        }.eraseToAnyPublisher()
    }
}
