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
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var description: String = ""
    @State private var birthDate: Date = Date()
    @State private var showNewPasswordFields: Bool = false
    
    var requiredDataIsValid: Bool {
        //print("Date: \(birthDate), \(store.state.profile.isValidDate(date: birthDate))")
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && store.state.profile.isValidDate(date: birthDate)
    }
    
    // MARK: - body
    var body: some View {
        contentView
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
    
    // MARK: - Content View
    fileprivate var contentView: some View {
        VStack {
            textFieldsView
            
            DatePicker(selection: $birthDate, displayedComponents: [.date]) {
                requiredText(text: "PROFILE_BIRTHDATE".localized)
            }
                .foregroundColor(.label)
                .accentColor(.main)
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
            .disabled(!requiredDataIsValid)
            .opacity(requiredDataIsValid ? 1.0 : 0.5)
            .buttonStyle(ConfirmButtonStyle())
            .padding()
        }
    }
    
    // MARK: - Text Fields
    fileprivate var textFieldsView: some View {
        Group {
            HStack {
                requiredText(text: "\("PROFILE_FIRST_NAME".localized)")
                    .frame(width: 120, alignment: .leading)
                TextField("PROFILE_FIRST_NAME".localized, text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            HStack {
                requiredText(text: "\("PROFILE_LAST_NAME".localized)")
                    .frame(width: 120, alignment: .leading)
                TextField("PROFILE_LAST_NAME".localized, text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            HStack {
                requiredText(text: "\("PROFILE_EMAIL".localized)")
                    .frame(width: 120, alignment: .leading)
                TextField("PROFILE_EMAIL".localized, text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            HStack {
                Text("\("PROFILE_ABOUT".localized)")
                    .frame(width: 120, alignment: .leading)
                TextField("", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - trailingNavBarItems
    fileprivate var trailingNavBarItemsView: some View {
        HStack {
            Button(action: {
                showNewPasswordFields.toggle()
            }, label: {
                Text("CHANGE_PASSWORD_TITLE".localized)
                    .foregroundColor(.main)
            })
                .fullScreenCover(isPresented: $showNewPasswordFields) {
                    screenFactory.makeChangePasswordView()
                }
        }
    }
    
    // MARK: - Required Text
    fileprivate func requiredText(text: String) -> some View {
        Text(text) + Text("REQUIRED".localized).foregroundColor(.red).baselineOffset(3)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeEditProfileView()
    }
}
