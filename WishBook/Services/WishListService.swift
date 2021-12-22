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
    func loadData(limit: Int) -> AnyPublisher<[WishListModel], Error>
    func loadMore() -> AnyPublisher<[WishListModel], Error>
    func addData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error>
    func updateData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error>
    func delete(id: String) -> AnyPublisher<Bool, Error>
}

final class WishListService: WishListServiceProtocol {
    private let db = Firestore.firestore()
    private var lastSnapshot: QueryDocumentSnapshot?
    
    func loadData(limit: Int) -> AnyPublisher<[WishListModel], Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty else { return }
                self?.db.collection(FirestoreCollection[.wishList])
                    .order(by: "createdTime")
                    .whereField("userId", isEqualTo: UserStorage.profileUserId)
                    .limit(to: limit)
                    .getDocuments { [weak self] querySnapshot, error in
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
        }.eraseToAnyPublisher()
    }
    
    func loadMore() -> AnyPublisher<[WishListModel], Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let snapshot = self?.lastSnapshot else {
                    promise(.success([]))
                    return
                }
                self?.db.collection(FirestoreCollection[.wishList])
                    .order(by: "createdTime")
                    .whereField("userId", isEqualTo: UserStorage.profileUserId)
                    .start(afterDocument: snapshot)
                    .limit(to: 20)
                    .getDocuments { querySnapshot, error in
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
        }.eraseToAnyPublisher()
    }
    
    func addData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty else { return }
                do {
                    var configuredData = data
                    configuredData.userId = UserStorage.profileUserId
                    let _ = try self?.db.collection(FirestoreCollection[.wishList])
                        .addDocument(from: configuredData)
                    promise(.success(configuredData))
                } catch {
                    print("addData error: \(error.localizedDescription)")
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error> {
        Deferred {
            Future { [weak self] promise in
                guard !UserStorage.profileUserId.isEmpty, let id = data.id else { return }
                var configuredData = data
                configuredData.userId = UserStorage.profileUserId
                do {
                    try self?.db.collection(FirestoreCollection[.wishList])
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
    
    func delete(id: String) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.db.collection(FirestoreCollection[.wishList])
                    .document(id)
                    .delete() { error in
                        if let error = error {
                            print("Error removing document: \(error.localizedDescription)")
                            promise(.failure(error))
                        } else {
                            print("Document successfully removed!")
                            promise(.success(true))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}
