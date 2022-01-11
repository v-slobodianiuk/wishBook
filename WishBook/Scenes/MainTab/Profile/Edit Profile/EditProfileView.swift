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
    
    var requiredDataIsValid: Bool {
        //print("Date: \(birthDate), \(store.state.profile.isValidDate(date: birthDate))")
        return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && store.state.profile.isValidDate(date: birthDate)
    }
    
    var body: some View {
        VStack {
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
            
            DatePicker(selection: $birthDate, displayedComponents: [.date]) {
                requiredText(text: "PROFILE_BIRTHDATE".localized)
            }
                .foregroundColor(.selectedTabItem)
                .accentColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
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
    
    fileprivate func requiredText(text: String) -> some View {
         Text(text) + Text("*").foregroundColor(.red).baselineOffset(3)
    }
    
//    func isValidDate(date: Date) -> Bool {
//        let dateComponents = Calendar.current.dateComponents([.year], from: Date(), to: date)
//        return (dateComponents.year ?? 0) >= 4
//    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeEditProfileView()
    }
}
