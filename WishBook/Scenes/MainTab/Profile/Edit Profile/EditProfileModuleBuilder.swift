//
//  EditProfileModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

enum EditProfileModuleBuilder {
    static func create(profileData: ProfileModel?) -> some View {
        let vm = EditProfileViewModel(repository: DI.getProfilePepository(), profileData: profileData)
        let profileView = EditProfileView(vm: vm)
        return profileView
    }
}
