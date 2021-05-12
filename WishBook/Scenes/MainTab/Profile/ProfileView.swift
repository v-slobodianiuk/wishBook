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
                .foregroundColor(.selectedTabItem)
                .padding(.top, 50)
            
            Text(vm.getFullName())
                .font(.title)
                .padding(.top)
                .padding(.horizontal)
                .padding(.horizontal)
            if let description = vm.getProfileData()?.description {
                Text(description)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            statisticView()
            HStack {
                Text("🎂")
                Text(vm.getBirthdate())
                    .padding(.leading, 5)
            }
            .padding()
            Spacer()
        }
    }
    
    fileprivate func statisticView() -> some View {
        HStack() {
            VStack {
                Text("\(vm.getProfileData()?.subscribers?.count ?? 0)")
                    .fontWeight(.medium)
                Text("PROFILE_SUBSCRIBERS_COUNT_TITLE".localized)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Divider()
                .frame(height: 25)
                .padding(.horizontal, 8)
            VStack {
                Text("\(vm.getProfileData()?.subscriptions?.count ?? 0)")
                    .fontWeight(.medium)
                Text("PROFILE_SUBSCRIPTIONS_COUNT_TITLE".localized)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Divider()
                .frame(height: 25)
                .padding(.horizontal, 8)
            VStack {
                Text("\(vm.getProfileData()?.wishes ?? 0)")
                    .fontWeight(.medium)
                Text("PROFILE_WISHES_COUNT_TITLE".localized)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel(router: ProfileRouter(), repository: ProfileRepository()))
    }
}
