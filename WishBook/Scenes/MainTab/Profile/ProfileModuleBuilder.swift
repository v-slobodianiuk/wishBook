//
//  ProfileModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

enum ProfileModuleBuilder {
    static func create() -> some View {
        let router = ProfileRouter()
        let vm = ProfileViewModel(router: router, repository: DI.getProfileRepository())
        let profileView = ProfileView(vm: vm)
        return profileView
    }
}

