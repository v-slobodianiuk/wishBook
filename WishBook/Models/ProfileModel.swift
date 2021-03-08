//
//  ProfileModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProfileModel: Codable {
    @DocumentID var id: String?
    var photoUrl: String?
    var firstName: String?
    var lastName: String?
    var birthdate: Date?
    var userId: String?
}
