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
}
