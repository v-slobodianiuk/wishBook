//
//  EditProfileView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct EditProfileView<VM: EditProfileViewModelProtocol>: View {
    @ObservedObject var vm: VM
    
    @State var firstName = ""
    @State var lastName = ""
    
    @State private var birthDate = Date()
    
    var body: some View {
        VStack {
            HStack {
                Text("\("PROFILE_FIRST_NAME".localized): ")
                    .frame(width: 100, alignment: .leading)
                TextField("PROFILE_FIRST_NAME".localized, text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
                .padding(.horizontal)
            HStack {
                Text("\("PROFILE_LAST_NAME".localized): ")
                    .frame(width: 100, alignment: .leading)
                TextField("PROFILE_LAST_NAME".localized, text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
                .padding(.horizontal)
            DatePicker("PROFILE_BIRTHDATE".localized, selection: $birthDate, displayedComponents: .date)
                .foregroundColor(.selectedTabItem)
                .padding(.horizontal)
            Spacer()
            Button(action: {
                vm.updateProfile(firstName: firstName, lastName: lastName, birthdate: birthDate)
            }, label: {
                Text("EDIT_PROFILE_BUTTON_TITLE".localized)
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.selectedTabItem)
                    .foregroundColor(.lightText)
                    .cornerRadius(10)
                
            })
            .padding()
            }
        .navigationBarTitle(Text("EDIT_PROFILE_TITLE".localized))
        .onAppear {
            firstName = vm.profileData.firstName ?? ""
            lastName = vm.profileData.lastName ?? ""
            birthDate = vm.profileData.birthdate ?? Date()
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(vm: EditProfileViewModel(repository: ProfileRepository(), profileData: ProfileModel()))
    }
}
