//
//  ChangePasswordView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 06.01.2022.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isValidPassword: Bool = false
    @State private var passwordPromptIsPresented: Bool = false
    
    var body: some View {
        let shouldDisplayError = Binding<Bool>(
            get: { store.state.auth.errorMessage != nil },
            set: { _ in store.dispatch(action: .auth(action: .fetchError(error: nil))) }
        )
        
        contentView
            .alert(isPresented: shouldDisplayError) {
                return Alert(
                    title: Text("Failed"),
                    message: Text(store.state.auth.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
    
    fileprivate var contentView: some View {
        ZStack {
            VStack {
                Spacer()
                
                Image(systemName: "lock.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                    .opacity(0.2)
                
                Spacer()
                
                Button {
                    endEditing()
                    withAnimation {
                        passwordPromptIsPresented.toggle()
                    }
                } label: {
                    HStack {
                        Text("Create new Password")
                            .font(Font.title)
                            .foregroundColor(.selectedTabItem)
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                    }
                }

                SecureField("Password", text: $password) {
                    withAnimation {
                        let isValid = store.state.auth.isValidPassword(password)
                        isValidPassword = (password == confirmPassword && isValid)
                    }
                }
                .onChange(of: password) { currentText in
                    withAnimation {
                        password = currentText.removeWrongCharacters()
                        let isValid = store.state.auth.isValidPassword(currentText)
                        isValidPassword = (password == confirmPassword && isValid)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Repeat Password", text: $confirmPassword) {
                    withAnimation {
                        let isValid = store.state.auth.isValidPassword(confirmPassword)
                        isValidPassword = (password == confirmPassword && isValid)
                    }
                }
                .onChange(of: confirmPassword) { currentText in
                    withAnimation {
                        confirmPassword = currentText.removeWrongCharacters()
                        let isValid = store.state.auth.isValidPassword(currentText)
                        isValidPassword = (password == confirmPassword && isValid)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if password != confirmPassword {
                    WarningText(text: "Password is not match")
                }
                
                Button("Confirm") {
                    store.dispatch(action: .auth(action: .updatePassword(password: password)))
                }
                .opacity(!isValidPassword ? 0.5 : 1.0)
                .disabled(!isValidPassword)
                .buttonStyle(ConfirmButtonStyle())
                .padding(.vertical)
                
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                }
                .padding()
                
            }
            .padding(.horizontal)

            if passwordPromptIsPresented {
                PasswordPromptView(isPresented: $passwordPromptIsPresented)
            }
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeChangePasswordView()
            //.preferredColorScheme(.dark)
    }
}
