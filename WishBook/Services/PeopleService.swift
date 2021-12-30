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
                print(#function)
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
}
