//
//  ProfileModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ProfileModel: Codable, Identifiable, Equatable {
    var id: String?
    var photoUrl: String?
    var firstName: String?
    var searchKey: String?
    var lastName: String?
    var email: String?
    var description: String?
    var birthdate: Date?
    var links: SocialLinksData?
    var wishes: Int?
    var subscribers: [String]?
    var subscriptions: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case photoUrl
        case firstName
        case lastName
        case searchKey
        case email
        case description
        case birthdate
        case links
        case wishes
        case subscribers
        case subscriptions
    }
    
    static func == (lhs: ProfileModel, rhs: ProfileModel) -> Bool {
        lhs.id == rhs.id
        && lhs.firstName == rhs.firstName
        && lhs.lastName == rhs.lastName
        && lhs.description == rhs.description
        && lhs.email == rhs.email
        && lhs.birthdate == rhs.birthdate
    }
}

struct SocialLinksData: Codable {
    var instagram: String?
    var telegram: String?
    var whatsApp: String?
    var viber: String?
}
