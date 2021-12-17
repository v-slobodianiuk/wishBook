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
    
}

final class WishListService: WishListServiceProtocol {
    private let db = Firestore.firestore()
    private lazy var firebaseUserId = Auth.auth().currentUser?.uid
}
