//
//  ProfileRepository.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol ProfileRepositoryProtocol {
    // Wrapped value
    var profile: ProfileModel { get }
    // (Published property wrapper)
    var profilePublished: Published<ProfileModel> { get }
    // Publisher
    var profilePublisher: Published<ProfileModel>.Publisher { get }
    
    func loadData()
    //func addData(_ data: ProfileModel)
    func updateData(_ data: ProfileModel)
    func addUserDataIfNeeded()
}

final class ProfileRepository: ProfileRepositoryProtocol, ObservableObject {
    
    private let db = Firestore.firestore()
    private lazy var user = Auth.auth().currentUser
    
    @Published var profile = ProfileModel()
    var profilePublished: Published<ProfileModel> { _profile }
    var profilePublisher: Published<ProfileModel>.Publisher { $profile }
    
    func addUserDataIfNeeded() {
        guard let userId = user?.uid, let email = user?.email else { fatalError() }
        print("user id: \(userId), \(email)")
        let userDoc = db.collection(FirestoreCollection[.users]).document(userId)
        userDoc.getDocument { (document, error) in
            if let error = error {
                print("LoadData error: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, !document.exists else { return }
            let confiredData = ProfileModel(email: email, userId: userId)
            do {
                try userDoc.setData(from: confiredData)
            } catch {
                print("updateData error: \(error.localizedDescription)")
            }
        }
    }
    
    func loadData() {
        guard let userId = user?.uid else { return }
        
        db.collection(FirestoreCollection[.users])
            .document(userId)
            //.whereField("userId", isEqualTo: userId)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                print("addSnapshotListener updated")
                if let error = error {
                    print("LoadData error: \(error.localizedDescription)")
                    return
                }
                
                if let querySnapshot = querySnapshot {
                    do {
                        self?.profile = try querySnapshot.data(as: ProfileModel.self) ?? ProfileModel()
                    } catch {
                        print("querySnapshot error: \(error.localizedDescription)")
                    }
                    //                    self.profile = querySnapshot.documents.compactMap {
                    //                        //try? $0.data(as: WishListModel.self)
                    //                        do {
                    //                            return try $0.data(as: ProfileModel.self)
                    //                        } catch {
                    //                            print("querySnapshot error: \(error.localizedDescription)")
                    //                            return nil
                    //                        }
                    //                    }
                }
            }
    }
    
    func updateData(_ data: ProfileModel) {
        guard let userId = user?.uid else { return }
        var confiredData = data
        confiredData.userId = userId
        do {
            try db.collection(FirestoreCollection[.users])
                .document(userId)
                .setData(from: confiredData)
        } catch {
            print("updateData error: \(error.localizedDescription)")
        }
    }
}
