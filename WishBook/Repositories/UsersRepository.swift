//
//  UsersRepository.swift
//  WishBook
//
//  Created by Vadym on 23.03.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol UsersRepositoryProtocol {
    // Wrapped value
    var users: [ProfileModel] { get }
    // (Published property wrapper)
    var usersPublished: Published<[ProfileModel]> { get }
    // Publisher
    var usersPublisher: Published<[ProfileModel]>.Publisher { get }
    
    func loadData()
    func searchData(_ key: String)
    func subscribeTo(id: String?)
    func unsubscribeFrom(id: String?)
}

final class UsersRepository: UsersRepositoryProtocol, ObservableObject {
    private let db = Firestore.firestore()
    private lazy var user = Auth.auth().currentUser
    
    @Published var users: [ProfileModel] = [ProfileModel]()
    var usersPublished: Published<[ProfileModel]> { _users }
    var usersPublisher: Published<[ProfileModel]>.Publisher { $users }
    
    func loadData() {
        db.collection(FirestoreCollection[.users])
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("LoadData error: \(error.localizedDescription)")
                }
                if let querySnapshot = querySnapshot {
                    self?.users = querySnapshot.documents.compactMap {
                        do {
                            return try $0.data(as: ProfileModel.self)
                        } catch {
                            print("querySnapshot error: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
    func searchData(_ key: String) {
        db.collection(FirestoreCollection[.users])
            .whereField("searchKey", isEqualTo: key)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("LoadData error: \(error.localizedDescription)")
                }
                if let querySnapshot = querySnapshot {
                    self?.users = querySnapshot.documents.compactMap {
                        do {
                            return try $0.data(as: ProfileModel.self)
                        } catch {
                            print("querySnapshot error: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
            }
    }
    
    func subscribeTo(id: String?) {
        guard let userId = user?.uid, let subscriptionId = id else { return }
        db.collection(FirestoreCollection[.users])
            .document(userId)
            .updateData([
                "subscriptions" : FieldValue.arrayUnion([subscriptionId])
            ]) { error in
                if let error = error {
                    print("subscribeTo error: \(error.localizedDescription)")
                }
            }
    }
    
    func unsubscribeFrom(id: String?) {
        guard let userId = user?.uid, let subscriptionId = id else { return }
        db.collection(FirestoreCollection[.users])
            .document(userId)
            .updateData([
                "subscriptions" : FieldValue.arrayRemove([subscriptionId])
            ]) { error in
                if let error = error {
                    print("subscribeTo error: \(error.localizedDescription)")
                }
            }
    }
}
