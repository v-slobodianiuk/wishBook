//
//  ProfileView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct ProfileView<VM: ProfileViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    
    var body: some View {
        Text("Profile View")
            .navigationBarTitle("Profile")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel())
    }
}
