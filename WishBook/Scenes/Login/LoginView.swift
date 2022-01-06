//
//  ContentView.swift
//  WishBook
//
//  Created by Vadym on 22.02.2021.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidEmail: Bool = false
    @State private var isValidPassword: Bool = false
    @State private var passwordPromptIsPresented: Bool = false
    
    var body: some View {
        let shouldDisplayError = Binding<Bool>(
            get: { store.state.auth.errorMessage != nil },
            set: { _ in store.dispatch(action: .auth(action: .fetchError(error: nil))) }
        )
        
        if store.state.auth.fetchInProgress {
            ProgressView()
        } else {
            ZStack {
                contentView
                    .alert(isPresented: shouldDisplayError) {
                        Alert(
                            title: Text(""),
                            message: Text("PASSWORD_PROMPT".localized),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                
                if passwordPromptIsPresented {
                    PasswordPromptView(isPresented: $passwordPromptIsPresented)
                }
            }
        }
    }
    
    fileprivate var contentView: some View {
        VStack(alignment: .leading) {
            TextField("Email", text: $email) {
                withAnimation {
                    isValidEmail = store.state.auth.isValidEmail(email)
                }
            }
            .onChange(of: email) { currentText in
                withAnimation {
                    email = currentText.removeWrongCharacters()
                    isValidEmail = store.state.auth.isValidEmail(currentText)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .padding(.horizontal)
            
            if !isValidEmail && !email.isEmpty {
                WarningText(text: "Incorrect email")
                    .padding(.horizontal)
                    .lineLimit(.max)
            }
            
            SecureField("Password", text: $password) {
                withAnimation {
                    isValidPassword = store.state.auth.isValidPassword(password)
                }
            }
            .onChange(of: password) { currentText in
                withAnimation {
                    password = currentText.removeWrongCharacters()
                    isValidPassword = store.state.auth.isValidPassword(currentText)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            
            if !isValidPassword && !password.isEmpty {
                Button {
                    endEditing()
                    withAnimation {
                        passwordPromptIsPresented.toggle()
                    }
                } label: {
                    HStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                        WarningText(text: "Incorrect password")
                    }
                }
                .padding(.leading)
            }
            
            if isValidEmail {
                Button {
                    store.dispatch(action: .auth(action: .resetPassword(email: email)))
                } label: {
                    Text("Reset password")
                        .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                        .padding([.horizontal])
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            Button {
                withAnimation {
                    store.dispatch(action: .auth(action: .logIn(login: email, password: password)))
                }
            } label: {
                Text("Log in")
                    .font(.title)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.lightText)
                    .opacity(!(isValidEmail && isValidPassword) ? 0.5 : 1.0)
                    .cornerRadius(10)
            }
            .padding([.horizontal, .top])
            .disabled(!(isValidEmail && isValidPassword))
            
            Button {
                withAnimation {
                    store.dispatch(action: .auth(action: .googleLogIn))
                }
            } label: {
                Text("Google")
                    .font(.title)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.lightText)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button {
                // MARK: - TODO
            } label: {
                Text("By signing in you accept our Privacy policy")
                    .font(Font.footnote)
                    .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                    .padding([.horizontal, .top])
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeLoginView()
    }
}
