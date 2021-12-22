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

enum ProfileKey: String {
    case wishesCount = "wishes"
    case photoUrl = "photoUrl"
}

protocol ProfileServiceProtocol {
    var wishCounterListener: ListenerRegistration? { get }
    
    func loadDataByUserId(_ userId: String?) -> AnyPublisher<ProfileModel, ProfileServiceError>
    func updateData(_ data: ProfileModel) -> AnyPublisher<ProfileModel, ProfileServiceError>
    func startWishesListener()
    func wishesCountPublisher() -> AnyPublisher<Int, Never>
    func updateDataBy(key: ProfileKey, value: Any) -> AnyPublisher<Bool, Never>
}

final class ProfileService: ProfileServiceProtocol {
    private let db = Firestore.firestore()
    lazy var profileUserId = Auth.auth().currentUser?.uid
    let subject = PassthroughSubject<Int, Never>()
    var wishCounterListener: ListenerRegistration?
    
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
    
    func startWishesListener() {
        guard let userId = profileUserId else { return }
        wishCounterListener = db.collection(FirestoreCollection[.wishList])
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let snapshotCount = querySnapshot?.count {
                    self?.subject.send(snapshotCount)
                }
            }
    }
    
    func wishesCountPublisher() -> AnyPublisher<Int, Never> {
        subject
            .eraseToAnyPublisher()
    }
    
    func updateDataBy(key: ProfileKey, value: Any) -> AnyPublisher<Bool, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let userId = self?.profileUserId else { return }
                
                self?.db.collection(FirestoreCollection[.users])
                    .document(userId)
                    .updateData([
                        key.rawValue : value
                    ]) { error in
                        if let error = error {
                            print("updateWishesCount error: \(error.localizedDescription)")
                            promise(.success(false))
                        }
                        promise(.success(true))
                    }
            }
        }.eraseToAnyPublisher()
    }
}
