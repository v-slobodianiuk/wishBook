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
    //func loadData() -> AnyPublisher<[WishListModel], Error>
    func loadData(limit: Int)
    func removeListener()
    func loadMore() -> AnyPublisher<[WishListModel], Error>
    func addData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error>
    func updateData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error>
    func delete(id: String) -> AnyPublisher<Bool, Error>
    
    func wishesSubject() -> AnyPublisher<[WishListModel], Never>
}

final class WishListService: WishListServiceProtocol {
    private let db = Firestore.firestore()
    private lazy var firebaseUserId = Auth.auth().currentUser?.uid
    private var lastSnapshot: QueryDocumentSnapshot?
    let subject = PassthroughSubject<[WishListModel], Never>()
    var wishListListener: ListenerRegistration?
    
//    func loadData() -> AnyPublisher<[WishListModel], Error> {
//        Deferred {
//            Future { [weak self] promise in
//                guard let userId = self?.firebaseUserId else { return }
//
//                self?.db.collection(FirestoreCollection[.wishList])
//                    .order(by: "createdTime")
//                    .whereField("userId", isEqualTo: userId)
//                    .limit(to: 20)
//                    .getDocuments { querySnapshot, error in
//
//                        self?.lastSnapshot = querySnapshot?.documents.last
//                        let result = Result {
//                            try querySnapshot?.documents.compactMap {
//                                try $0.data(as: WishListModel.self)
//
//                            }
//                        }
//
//                        switch result {
//                        case .success(let documents):
//                            guard let wishList = documents else {
//                                // A nil value was successfully initialized from the DocumentSnapshot,
//                                // or the DocumentSnapshot was nil.
//                                return
//                            }
//
//                            // Data value was successfully initialized from the DocumentSnapshot.
//                            promise(.success(wishList))
//
//                            guard let lastSnap = self?.lastSnapshot else { return }
//                            let _ = self?.db.collection(FirestoreCollection[.wishList])
//                                .order(by: "createdTime")
//                                .whereField("userId", isEqualTo: userId)
//                                .start(afterDocument: lastSnap)
//
//                                // Use the query for pagination.
//                                // ...
//                        case .failure(let error):
//                            // Data value could not be initialized from the DocumentSnapshot.
//                            promise(.failure(error))
//                        }
//                    }
//            }
//        }.eraseToAnyPublisher()
//    }
    
    func wishesSubject() -> AnyPublisher<[WishListModel], Never> {
        return subject
            .eraseToAnyPublisher()
    }
    
    func loadData(limit: Int) {
        print("Load Wishes service: \(Thread.current)")
        guard let userId = firebaseUserId else { return }
        
        wishListListener = db.collection(FirestoreCollection[.wishList])
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .limit(to: limit)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                print("Load Wishes snapshot listener: \(Thread.current)")
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
                        return
                    }
                    
                    // Data value was successfully initialized from the DocumentSnapshot.
                    self?.subject.send(wishList)
                case .failure(let error):
                    // Data value could not be initialized from the DocumentSnapshot.
                    print(error.localizedDescription)
                }
            }
    }
    
    func loadMore() -> AnyPublisher<[WishListModel], Error> {
        Deferred {
            Future { [weak self] promise in
                print("Load more Wishes service Feature: \(Thread.current)")
                guard let userId = self?.firebaseUserId, let snapshot = self?.lastSnapshot else {
                    promise(.success([]))
                    return
                }
                
                self?.db.collection(FirestoreCollection[.wishList])
                    .order(by: "createdTime")
                    .whereField("userId", isEqualTo: userId)
                    .start(afterDocument: snapshot)
                    .limit(to: 20)
                    .getDocuments { querySnapshot, error in
                        print("Load more Wishes service get documents: \(Thread.current)")
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
    
    func removeListener() {
        wishListListener?.remove()
    }
    
    func addData(_ data: WishListModel) -> AnyPublisher<WishListModel, Error> {
        Deferred {
            Future { [weak self] promise in
                do {
                    var configuredData = data
                    configuredData.userId = self?.firebaseUserId
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
                guard let userId = self?.firebaseUserId, let id = data.id else { return }
                var configuredData = data
                configuredData.userId = userId
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
