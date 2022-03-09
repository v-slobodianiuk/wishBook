//
//  WishListModel.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WishListModel: Codable, Identifiable, Equatable {
    @DocumentID var id: String?
    var createdTime: Date = Date()
    var userId: String?
    var title: String
    var description: String?
    var url: String?
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
 
