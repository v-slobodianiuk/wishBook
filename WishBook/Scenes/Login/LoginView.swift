//
//  ContentView.swift
//  WishBook
//
//  Created by Vadym on 22.02.2021.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isValidEmail: Bool = false
    @State private var isValidPassword: Bool = false
    @State private var passwordPromptIsPresented: Bool = false
    @State private var currentNonce: String?
    
    var body: some View {
        let shouldDisplayError = Binding<Bool>(
            get: { store.state.auth.errorMessage != nil },
            set: { _ in store.dispatch(action: .auth(action: .fetchError(error: nil))) }
        )
        
        let shouldDisplayPasswordResetSuccess = Binding<Bool>(
            get: { store.state.auth.successfullyPaswordReset },
            set: { _ in store.dispatch(action: .auth(action: .resetPasswordComplete(success: false))) }
        )
        
        if store.state.auth.fetchInProgress {
            ProgressView()
        } else {
            ZStack {
                contentView
                    .frame(maxHeight: .infinity)
                    //.contentShape(Rectangle())
                    //.resignKeyboardOnTapGesture()
                    .alert(isPresented: shouldDisplayError) {
                        Alert(
                            title: Text("Failed"),
                            message: Text(store.state.auth.errorMessage ?? ""),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                
                if passwordPromptIsPresented {
                    PasswordPromptView(isPresented: $passwordPromptIsPresented)
                }
                
                if store.state.auth.successfullyPaswordReset {
                    ResetPasswordView(isPresented: shouldDisplayPasswordResetSuccess)
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
                    endEditing()
                    withAnimation {
                        store.dispatch(action: .auth(action: .resetPassword(email: email)))
                    }
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
                Text("Sign in")
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
            
            SignInWithAppleButton(.continue) { request in
                let nonce = CryptoService.randomNonceString()
                currentNonce = nonce
                request.requestedScopes = [.fullName, .email]
                request.nonce = CryptoService.sha256(nonce)
            } onCompletion: { result in
                guard let nonce = currentNonce else { return }
                store.dispatch(action: .auth(action: .sighInWithApple(nonce: nonce, result: result)))
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 50)
            .cornerRadius(10)
            .padding(.horizontal)
            
            Link("By signing in you accept our Privacy policy", destination: URL(string: "https://apple.com")!)
                .font(Font.footnote)
                .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                .padding([.horizontal, .top])
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeLoginView()
    }
}
