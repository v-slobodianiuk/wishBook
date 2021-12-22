//
//  EditProfileView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var description = ""
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
            Button(action: {
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
            }, label: {
                Text("EDIT_PROFILE_BUTTON_TITLE".localized)
                    .font(.title)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.lightText)
                    .cornerRadius(10)
                
            })
            .padding()
            }
        .navigationBarTitle(Text("EDIT_PROFILE_TITLE".localized))
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
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeEditProfileView()
    }
}
