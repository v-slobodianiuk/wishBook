//
//  PeopleService.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation
import Firebase
import Combine

protocol PeopleServiceProtocol {
    func sendSearchText(_ text: String)
    func searchPublisher() -> AnyPublisher<String, Never>?
    func cancellPreviousSearch()
    func searchData(key: String) -> AnyPublisher<[ProfileModel],Error>
    func loadMore() -> AnyPublisher<[ProfileModel], Error>
    
    func addToSubscriptions(id: String?) -> AnyPublisher<Bool, Error>
    func removeFromSubscriptions(id: String?) -> AnyPublisher<Bool, Error>
    
    func addToSubscribers(id: String?) -> AnyPublisher<Bool, Error>
    func removeFromSubscribers(id: String?) -> AnyPublisher<Bool, Error>
}

final class PeopleService: PeopleServiceProtocol {
    private let db = Firestore.firestore()
    private var lastSnapshot: QueryDocumentSnapshot?
    private var searchKey: String = ""
    private var subject: PassthroughSubject<String, Never>?
    
    func sendSearchText(_ text: String) {
        subject?.send(text)
    }
    
    func searchPublisher() -> AnyPublisher<String, Never>? {
        guard subject == nil else { return nil }
        subject = PassthroughSubject<String, Never>()
        return subject?.eraseToAnyPublisher()
    }
    
    func cancellPreviousSearch() {
        subject?.send(completion: .finished)
        subject = nil
    }
    
    func searchData(key: String) -> AnyPublisher<[ProfileModel], Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self, !UserStorage.profileUserId.isEmpty else {
                    return
                }
                
                self.searchKey = key
                self.db.collection(FirestoreCollection[.users])
                    .whereField("searchKey", isEqualTo: self.searchKey)
                    .limit(to: 20)
                    .getDocuments { querySnapshot, error in
                        self.lastSnapshot = querySnapshot?.documents.last
                        let result = Result {
                            try querySnapshot?.documents.compactMap {
                                try $0.data(as: ProfileModel.self)
                            }
                        }
                        
                        switch result {
                        case .success(let documents):
                            guard let peopleList = documents?.filter({ $0.id != UserStorage.profileUserId }) else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                promise(.success([]))
                                return
                            }
                            
                            // Data value was successfully initialized from the DocumentSnapshot.
                            promise(.success(peopleList))
                        case .failure(let error):
                            // Data value could not be initialized from the DocumentSnapshot.
                            promise(.failure(error))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func loadMore() -> AnyPublisher<[ProfileModel], Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self, let snapshot = self.lastSnapshot, !UserStorage.profileUserId.isEmpty else {
                    return
                }
                
                self.db.collection(FirestoreCollection[.users])
                    .whereField("searchKey", isEqualTo: self.searchKey)
                    .start(afterDocument: snapshot)
                    .limit(to: 20)
                    .getDocuments { querySnapshot, error in
                        self.lastSnapshot = querySnapshot?.documents.last
                        let result = Result {
                            try querySnapshot?.documents.compactMap {
                                try $0.data(as: ProfileModel.self)
                            }
                        }
                        
                        switch result {
                        case .success(let documents):
                            guard let peopleList = documents?.filter({ $0.id == UserStorage.profileUserId }) else {
                                // A nil value was successfully initialized from the DocumentSnapshot,
                                // or the DocumentSnapshot was nil.
                                promise(.success([]))
                                return
                            }
                            
                            // Data value was successfully initialized from the DocumentSnapshot.
                            promise(.success(peopleList))
                        case .failure(let error):
                            // Data value could not be initialized from the DocumentSnapshot.
                            promise(.failure(error))
                        }
                    }
            }

        }.eraseToAnyPublisher()
    }
    
    func addToSubscriptions(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }
                
                self?.db.collection(FirestoreCollection[.users])
                    .document(UserStorage.profileUserId)
                    .updateData([
                        "subscriptions" : FieldValue.arrayUnion([subscriptionId])
                    ]) { error in
                        if let error = error {
                            promise(.failure(error))
                            print("subscribeTo error: \(error.localizedDescription)")
                        }
                        
                        promise(.success(true))
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func removeFromSubscriptions(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }
                self?.db.collection(FirestoreCollection[.users])
                    .document(UserStorage.profileUserId)
                    .updateData([
                        "subscriptions" : FieldValue.arrayRemove([subscriptionId])
                    ]) { error in
                        if let error = error {
                            promise(.failure(error))
                            print("unsubscribeFrom error: \(error.localizedDescription)")
                        }
                        
                        promise(.success(true))
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func addToSubscribers(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }
                    
                self?.db.collection(FirestoreCollection[.users])
                    .document(subscriptionId)
                    .updateData([
                        "subscribers" : FieldValue.arrayUnion([UserStorage.profileUserId])
                    ]) { error in
                        if let error = error {
                            promise(.failure(error))
                            print("Add to subscribers error: \(error.localizedDescription)")
                        }

                        promise(.success(true))
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func removeFromSubscribers(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }
                    
                self?.db.collection(FirestoreCollection[.users])
                    .document(subscriptionId)
                    .updateData([
                        "subscribers" : FieldValue.arrayRemove([UserStorage.profileUserId])
                    ]) { error in
                        if let error = error {
                            promise(.failure(error))
                            print("Remove from subscribers error: \(error.localizedDescription)")
                        }

                        promise(.success(true))
                    }
            }
        }.eraseToAnyPublisher()
    }
}
