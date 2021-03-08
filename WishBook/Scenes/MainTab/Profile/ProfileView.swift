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
        ZStack {
            if vm.emptyViewIsHidden() {
                profileBlock()
            } else {
                emptyView()
            }
        }
        .navigationBarTitle("PROFILE_NAV_TITLE".localized)
        .navigationBarItems(trailing: setupTrailingNavBarItems())
        .onAppear {
            vm.getData()
        }
    }
    
    fileprivate func setupTrailingNavBarItems() -> some View {
        HStack {
            vm.router.goEditProfile(profileData: vm.getProfileData()) {
                Text("PROFILE_EDIT_BUTTON_TITLE".localized)
            }
            Button(action: {
                vm.signOut()
            }, label: {
                Text("PROFILE_SIGN_OUT_BUTTON_TITLE".localized)
            })
        }
    }
    
    fileprivate func emptyView() -> some View {
        vm.router.goEditProfile(profileData: vm.getProfileData()) {
            VStack(alignment: .center) {
                Text("🙈")
                    .font(.system(size: 100))
                    .padding()
                Text("EMPTY_VIEW_TITLE".localized)
                    .padding()
            }
        }
    }
    
    fileprivate func profileBlock() -> some View {
        VStack(alignment: .center) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.gray)
                .padding(.top, 50)
            
            Text(vm.getFullName())
                .font(.title)
                .padding()
            Divider()
                .padding()
            HStack {
                Text(vm.getBirthdate())
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.selectedTabItem)
            .cornerRadius(15)
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel(router: ProfileRouter(), repository: ProfileRepository()))
    }
}
