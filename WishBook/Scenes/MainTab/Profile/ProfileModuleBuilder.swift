//
//  ProfileModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

enum ProfileModuleBuilder {
    static func create() -> some View {
        let vm = ProfileViewModel()
        let profileView = ProfileView(vm: vm)
        return profileView
    }
}

