//
//  EditProfileViewModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation

protocol EditProfileViewModelProtocol: ObservableObject {
    var profileData: ProfileModel { get }
    func updateProfile(firstName: String?, lastName: String?, birthdate: Date?)
}

final class EditProfileViewModel: EditProfileViewModelProtocol {
    var profileData: ProfileModel
    let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol, profileData: ProfileModel?) {
        self.repository = repository
        self.profileData = profileData ?? ProfileModel()
    }
    
    func updateProfile(firstName: String?, lastName: String?, birthdate: Date?) {
        profileData.firstName = firstName
        profileData.lastName = lastName
        profileData.birthdate = birthdate
        repository.updateData(profileData)
    }
}
