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
    func searchData(key: String) -> AnyPublisher<[ProfileModel], Error>

    func addToSubscriptions(id: String?) -> AnyPublisher<Bool, Error>
    func removeFromSubscriptions(id: String?) -> AnyPublisher<Bool, Error>

    func addToSubscribers(id: String?) -> AnyPublisher<Bool, Error>
    func removeFromSubscribers(id: String?) -> AnyPublisher<Bool, Error>

    func loadPeopleByFilter(profile: ProfileModel, filter: PeopleFilter) -> AnyPublisher<[ProfileModel], Error>
}

final class PeopleService: PeopleServiceProtocol {
    private let db = Firestore.firestore()
    private var lastSnapshot: QueryDocumentSnapshot?
    private var searchKey: String = ""
    private var subject: PassthroughSubject<String, Never>?

    // MARK: - Search publisher
    func searchPublisher() -> AnyPublisher<String, Never>? {
        guard subject == nil else { return nil }
        subject = PassthroughSubject<String, Never>()
        return subject?.eraseToAnyPublisher()
    }

    func sendSearchText(_ text: String) {
        subject?.send(text)
    }

    func cancellPreviousSearch() {
        subject?.send(completion: .finished)
        subject = nil
    }

    // MARK: - Search by key
    func searchData(key: String) -> AnyPublisher<[ProfileModel], Error> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self, !UserStorage.profileUserId.isEmpty else {
                    return
                }

                self.searchKey = key
                self.db.collection(Globals.usersCollectionName)
                    .whereField("searchKey", isEqualTo: self.searchKey)
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

    // MARK: - Add To Subscriptions
    func addToSubscriptions(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }

                self?.db.collection(Globals.usersCollectionName)
                    .document(UserStorage.profileUserId)
                    .updateData([
                        "subscriptions": FieldValue.arrayUnion([subscriptionId])
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

    // MARK: - REmove from Subscriptions
    func removeFromSubscriptions(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }
                self?.db.collection(Globals.usersCollectionName)
                    .document(UserStorage.profileUserId)
                    .updateData([
                        "subscriptions": FieldValue.arrayRemove([subscriptionId])
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

    // MARK: - Add To Subscribers
    func addToSubscribers(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }

                self?.db.collection(Globals.usersCollectionName)
                    .document(subscriptionId)
                    .updateData([
                        "subscribers": FieldValue.arrayUnion([UserStorage.profileUserId])
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

    // MARK: - Remove from Subscribers
    func removeFromSubscribers(id: String?) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let subscriptionId = id else { return }

                self?.db.collection(Globals.usersCollectionName)
                    .document(subscriptionId)
                    .updateData([
                        "subscribers": FieldValue.arrayRemove([UserStorage.profileUserId])
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

    // MARK: - Load by filter
    func loadPeopleByFilter(profile: ProfileModel, filter: PeopleFilter) -> AnyPublisher<[ProfileModel], Error> {
            Deferred {
                Future { [weak self] promise in
                    var searchedIds: [String]?

                    switch filter {
                    case .subscribers:
                        searchedIds = profile.subscribers
                    case .subscriptions:
                        searchedIds = profile.subscriptions
                    default: break
                    }

                    guard let searchedIds = searchedIds, !searchedIds.isEmpty else {
                        promise(.success([]))
                        return
                    }

                    self?.db.collection(Globals.usersCollectionName)
                        .whereField("userId", in: searchedIds)
                        .getDocuments { (querySnapshot, error) in
                            DispatchQueue.global().async {
                                let result = Result {
                                    try querySnapshot?.documents.compactMap {
                                        try $0.data(as: ProfileModel.self)
                                    }
                                }

                                switch result {
                                case .success(let documents):
                                    guard let peopleList = documents else {
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

                }
            }.eraseToAnyPublisher()
        }
}
