//
//  UsersRepository.swift
//  WishBook
//
//  Created by Vadym on 23.03.2021.
//

//import Foundation
//import Firebase
//import FirebaseFirestore
//
//protocol UsersRepositoryProtocol {
//    // Wrapped value
//    var users: [ProfileModel] { get }
//    // (Published property wrapper)
//    var usersPublished: Published<[ProfileModel]> { get }
//    // Publisher
//    var usersPublisher: Published<[ProfileModel]>.Publisher { get }
//    
//    func loadData()
//    func searchData(_ key: String)
//    func subscribeTo(id: String?)
//    func unsubscribeFrom(id: String?)
//    func loadPeopleByFilter(_ filter: PeopleFilter)
//}
//
//final class UsersRepository: UsersRepositoryProtocol, ObservableObject {
//    private let db = Firestore.firestore()
//    private lazy var user = Auth.auth().currentUser
//    
//    @Published var users: [ProfileModel] = [ProfileModel]()
//    var usersPublished: Published<[ProfileModel]> { _users }
//    var usersPublisher: Published<[ProfileModel]>.Publisher { $users }
//    var peopleIds: [String]?
//    
//    private func getUsersIdsByFilter(_ filter: PeopleFilter, completion: @escaping (([String]?) -> Void)) {
//        guard let userId = user?.uid else {
//            completion(nil)
//            return
//        }
//        
//        db.collection(FirestoreCollection[.users])
//            .document(userId)
//            .getDocument { (document, error) in
//                if let document = document, document.exists {
//                    do {
//                        let userData = try document.data(as: ProfileModel.self)
//                        if let data = userData {
//                            switch filter {
//                            case .subscribers:
//                                completion(data.subscribers)
//                            case .subscriptions:
//                                completion(data.subscriptions)
//                            default:
//                                completion(nil)
//                            }
//                        }
//                    } catch {
//                        completion(nil)
//                        print("querySnapshot error: \(error.localizedDescription)")
//                    }
//                } else {
//                    completion(nil)
//                    print("Document does not exist")
//                }
//            }
//    }
//    
//    func loadData() {
//        guard let userId = user?.uid else { return }
//        
//        db.collection(FirestoreCollection[.users])
//            .getDocuments { [weak self] (querySnapshot, error) in
//                if let error = error {
//                    print("LoadData error: \(error.localizedDescription)")
//                }
//                if let querySnapshot = querySnapshot {
//                    self?.users = querySnapshot.documents.compactMap {
//                        do {
//                            return try $0.data(as: ProfileModel.self)
//                        } catch {
//                            print("querySnapshot error: \(error.localizedDescription)")
//                            return nil
//                        }
//                    }.filter { $0.id != userId }
//                }
//            }
//    }
//    
//    func searchData(_ key: String) {
//        guard let userId = user?.uid else { return }
//        
//        db.collection(FirestoreCollection[.users])
//            .whereField("searchKey", isEqualTo: key)
//            .getDocuments { [weak self] (querySnapshot, error) in
//                if let error = error {
//                    print("LoadData error: \(error.localizedDescription)")
//                }
//                if let querySnapshot = querySnapshot {
//                    self?.users = querySnapshot.documents.compactMap {
//                        do {
//                            return try $0.data(as: ProfileModel.self)
//                        } catch {
//                            print("querySnapshot error: \(error.localizedDescription)")
//                            return nil
//                        }
//                    }.filter { $0.id != userId }
//                }
//            }
//    }
//    
//    func subscribeTo(id: String?) {
//        guard let userId = user?.uid, let subscriptionId = id else { return }
//        db.collection(FirestoreCollection[.users])
//            .document(userId)
//            .updateData([
//                "subscriptions" : FieldValue.arrayUnion([subscriptionId])
//            ]) { error in
//                if let error = error {
//                    print("subscribeTo error: \(error.localizedDescription)")
//                }
//            }
//    }
//    
//    func unsubscribeFrom(id: String?) {
//        guard let userId = user?.uid, let subscriptionId = id else { return }
//        db.collection(FirestoreCollection[.users])
//            .document(userId)
//            .updateData([
//                "subscriptions" : FieldValue.arrayRemove([subscriptionId])
//            ]) { error in
//                if let error = error {
//                    print("subscribeTo error: \(error.localizedDescription)")
//                }
//            }
//    }
//    
//    func loadPeopleByFilter(_ filter: PeopleFilter) {
//        getUsersIdsByFilter(filter) { [weak self] ids in
//            guard let safeIds: [String] = ids, !safeIds.isEmpty else { return }
//            
//            self?.db.collection(FirestoreCollection[.users])
//                .whereField("userId", in: safeIds)
//                .getDocuments { [weak self] (querySnapshot, error) in
//                    if let error = error {
//                        print("LoadData error: \(error.localizedDescription)")
//                    }
//                    if let querySnapshot = querySnapshot {
//                        self?.users = querySnapshot.documents.compactMap {
//                            do {
//                                return try $0.data(as: ProfileModel.self)
//                            } catch {
//                                print("querySnapshot error: \(error.localizedDescription)")
//                                return nil
//                            }
//                        }
//                    }
//                }
//        }
//    }
//}
