//
//  LoginModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 17.03.2021.
//

import SwiftUI

enum LoginModuleBuilder {
    static func create() -> some View {
        let vm = LoginViewModel(googleAuthService: DI.getGoogleAuthService(), repository: DI.getProfileRepository())
        let wishDetailsView = LoginView(vm: vm)
        return wishDetailsView
    }
}
