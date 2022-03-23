//
//  WishListService.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 17.12.2021.
//

import Foundation
import Combine
import Firebase

protocol WishListServiceProtocol {
    func loadData(userId: String, limit: Int) -> AnyPublisher<[WishListModel], Error>
    func loadMore(userId: String) -> AnyPublisher<[WishListModel], Error>
    func addData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error>
    func updateData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error>
    func delete(id: String) -> AnyPublisher<Bool, Error>
}

final class WishListService: WishListServiceProtocol {
    private let db = Firestore.firestore()
    private var lastSnapshot: QueryDocumentSnapshot?

    // MARK: - Load wishes
    func loadData(userId: String, limit: Int) -> AnyPublisher<[WishListModel], Error> {
        Deferred {
            Future { [weak self] promise in

                self?.db.collection(Globals.wishesCollectionName)
                    .order(by: "createdTime")
                    .whereField("userId", isEqualTo: userId)
                    .limit(to: limit)
                    .getDocuments { [weak self] querySnapshot, error in
                        DispatchQueue.global().async {
                            self?.lastSnapshot = querySnapshot?.documents.last
                            let result = Result {
                                try querySnapshot?.documents.compactMap {
                                    try $0.data(as: WishListModel.self)

                                }
                            }

                            switch result {
                            case .success(let documents):
                                guard let wishList = documents else {
                                    // A nil value was successfully initialized from the DocumentSnapshot,
                                    // or the DocumentSnapshot was nil.
                                    promise(.success([]))
                                    return
                                }

                                // Data value was successfully initialized from the DocumentSnapshot.
                                promise(.success(wishList))
                            case .failure(let error):
                                // Data value could not be initialized from the DocumentSnapshot.
                                promise(.failure(error))
                            }
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: - Load more wishes
    func loadMore(userId: String) -> AnyPublisher<[WishListModel], Error> {
        Deferred {
            Future { [weak self] promise in
                guard let snapshot = self?.lastSnapshot else {
                    promise(.success([]))
                    return
                }

                self?.db.collection(Globals.wishesCollectionName)
                    .order(by: "createdTime")
                    .whereField("userId", isEqualTo: userId)
                    .start(afterDocument: snapshot)
                    .limit(to: 20)
                    .getDocuments { querySnapshot, error in
                        DispatchQueue.global().async {
                            self?.lastSnapshot = querySnapshot?.documents.last
                            let result = Result {
                                try querySnapshot?.documents.compactMap {
                                    try $0.data(as: WishListModel.self)

                                }
                            }

                            switch result {
                            case .success(let documents):
                                guard let wishList = documents else {
                                    // A nil value was successfully initialized from the DocumentSnapshot,
                                    // or the DocumentSnapshot was nil.
                                    promise(.success([]))
                                    return
                                }

                                // Data value was successfully initialized from the DocumentSnapshot.
                                promise(.success(wishList))
                            case .failure(let error):
                                // Data value could not be initialized from the DocumentSnapshot.
                                promise(.failure(error))
                            }
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }

    // MARK: - Add new wish item
    func addData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty else {
                    return
                }

                do {
                    var configuredData = data
                    configuredData.userId = UserStorage.profileUserId
                    _ = try self?.db.collection(Globals.wishesCollectionName)
                        .addDocument(from: configuredData)
                    promise(.success(configuredData))
                } catch {
                    print("addData error: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // MARK: - Update wish item
    func updateData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let id = data.id else {
                    return
                }

                var configuredData = data
                configuredData.userId = UserStorage.profileUserId

                do {
                    try self?.db.collection(Globals.wishesCollectionName)
                        .document(id)
                        .setData(from: configuredData)
                    promise(.success(configuredData))
                } catch {
                    print("updateData error: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // MARK: - Delete wish item
    func delete(id: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.db.collection(Globals.wishesCollectionName)
                    .document(id)
                    .delete { error in
                        DispatchQueue.global().async {
                            if let error = error {
                                print("Error removing document: \(error.localizedDescription)")
                                promise(.failure(error))
                            } else {
                                print("Document successfully removed!")
                                promise(.success(true))
                            }
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
