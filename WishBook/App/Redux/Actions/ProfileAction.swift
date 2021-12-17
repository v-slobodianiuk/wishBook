//
//  ProfileAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

enum ProfileAction {
    case fetch
    case fetchComplete(data: ProfileModel)
    case fetchError(error: String?)
    case uploadProfilePhoto(data: Data)
    case updateProfileData(firstName: String, lastName: String, description: String, email: String, birthDate: Date)
    case profileUpdated(data: ProfileModel)
}
