//
//  FirestoreCollection.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation

enum FirestoreCollection: String {
    case users = "Users"
    case wishList = "WishList"
    
    static subscript(_ item: FirestoreCollection) -> String {
        return item.rawValue
    }
}
