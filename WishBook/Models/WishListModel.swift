//
//  WishListModel.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WishListModel: Codable, Identifiable {
    @DocumentID var id: String?
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
    var title: String
    var description: String?
    var url: String?
}
 
