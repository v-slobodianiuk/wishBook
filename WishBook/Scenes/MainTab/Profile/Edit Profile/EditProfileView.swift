//
//  EditProfileView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI
import Foundation

struct EditProfileView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var description: String = ""
    @State private var birthDate: Date = Date()
    @State private var showNewPasswordFields: Bool = false
    
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
            
            HStack {
                Text("\("PROFILE_EMAIL".localized): ")
                    .frame(width: 100, alignment: .leading)
                TextField("PROFILE_EMAIL".localized, text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            HStack(alignment: .top) {
                Text("\("PROFILE_ABOUT".localized): ")
                    .frame(width: 100, alignment: .leading)
                TextView(text: $description)
                    .font(.systemFont(ofSize: 17))
                    .setBorder(borderColor: .lightGray, borderWidth: 0.25, cornerRadius: 5)
                    .frame(maxWidth: .infinity, maxHeight: 150)
            }
            .padding(.horizontal)
            
            DatePicker("PROFILE_BIRTHDATE".localized, selection: $birthDate, displayedComponents: .date)
                .foregroundColor(.selectedTabItem)
                .padding(.horizontal)
            
            Spacer()
            
            Button("EDIT_PROFILE_BUTTON_TITLE".localized) {
                store.dispatch(
                    action: .profile(
                        action: .updateProfileData(
                            firstName: firstName,
                            lastName: lastName,
                            description: description,
                            email: email,
                            birthDate: birthDate
                        )
                    )
                )
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(ConfirmButtonStyle())
            .padding()
        }
        .navigationBarTitle(Text("EDIT_PROFILE_TITLE".localized))
        .navigationBarItems(trailing: trailingNavBarItemsView)
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
        .onAppear {
            firstName = store.state.profile.profileData?.firstName ?? ""
            lastName = store.state.profile.profileData?.lastName ?? ""
            description = store.state.profile.profileData?.description ?? ""
            email = store.state.profile.profileData?.email ?? ""
            birthDate = store.state.profile.profileData?.birthdate ?? Date()
        }
    }
    
    fileprivate var trailingNavBarItemsView: some View {
        HStack {
            Button(action: {
                showNewPasswordFields.toggle()
            }, label: {
                Text("Change Password".localized)
                    .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
            })
                .fullScreenCover(isPresented: $showNewPasswordFields) {
                    screenFactory.makeChangePasswordView()
                }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeEditProfileView()
    }
}
