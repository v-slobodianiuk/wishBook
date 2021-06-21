//
//  WishListRepository.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol WishListRepositoryProtocol {
    // Wrapped value
    var wishList: [WishListModel] { get }
    // (Published property wrapper)
    var wishListPublished: Published<[WishListModel]> { get }
    // Publisher
    var wishListPublisher: Published<[WishListModel]>.Publisher { get }
    
    func loadData()
    func addData(_ data: WishListModel)
    func updateData(_ data: WishListModel)
    func delete(id: String?)
    func loadDataByUserId(_ userId: String)
}

final class WishListRepository: WishListRepositoryProtocol, ObservableObject {
    private let db = Firestore.firestore()
    private lazy var firebaseUserId = Auth.auth().currentUser?.uid
    
    @Published var wishList: [WishListModel] = [WishListModel]()
    var wishListPublished: Published<[WishListModel]> { _wishList }
    var wishListPublisher: Published<[WishListModel]>.Publisher { $wishList }
    
    func loadData() {
        guard let userId = firebaseUserId else { return }
        
        db.collection(FirestoreCollection[.wishList])
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("LoadData error: \(error.localizedDescription)")
                }
                
                if let querySnapshot = querySnapshot {
                    self?.updateWishesCount(querySnapshot.count)
                    self?.wishList = querySnapshot.documents.compactMap {
                        //try? $0.data(as: WishListModel.self)
                        do {
                            return try $0.data(as: WishListModel.self)
                        } catch {
                            print("querySnapshot error: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
    func addData(_ data: WishListModel) {
        do {
            var confiredData = data
            confiredData.userId = firebaseUserId
            let _ = try db.collection(FirestoreCollection[.wishList])
                .addDocument(from: confiredData)
        } catch {
            print("addData error: \(error.localizedDescription)")
        }
    }
    
    func updateData(_ data: WishListModel) {
        guard let userId = firebaseUserId, let id = data.id else { return }
        var confiredData = data
        confiredData.userId = userId
        do {
            try db.collection(FirestoreCollection[.wishList])
                .document(id)
                .setData(from: confiredData)
        } catch {
            print("updateData error: \(error.localizedDescription)")
        }
    }
    
    func delete(id: String?) {
        guard let id = id else { return }
        db.collection(FirestoreCollection[.wishList])
            .document(id)
            .delete() { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    private func updateWishesCount(_ wishesCount: Int) {
        guard let userId = firebaseUserId else { return }
        
        db.collection(FirestoreCollection[.users])
            .document(userId)
            .updateData([
                "wishes" : wishesCount
            ]) { error in
                if let error = error {
                    print("updateWishesCount error: \(error.localizedDescription)")
                }
            }
    }
    
    func loadDataByUserId(_ userId: String) {
        db.collection(FirestoreCollection[.wishList])
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] querySnapshot, error in
                if let error = error {
                    print("LoadData error: \(error.localizedDescription)")
                    return
                }
                if let querySnapshot = querySnapshot {
                    self?.wishList = querySnapshot.documents.compactMap {
                        //try? $0.data(as: WishListModel.self)
                        do {
                            return try $0.data(as: WishListModel.self)
                        } catch {
                            print("querySnapshot error: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
}
