//
//  ContentView.swift
//  WishBook
//
//  Created by Vadym on 22.02.2021.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var store: AppStore
    @State private var login: String = ""
    @State private var password: String = ""
    
    var body: some View {
        if store.state.auth.fetchInProgress {
            ProgressView()
        } else {
            loginFormsView()
        }
    }
    
    private func loginFormsView() -> some View {
        let shouldDisplayError =  Binding<Bool>(
            get: { store.state.auth.errorMessage != nil },
            set: { _ in store.dispatch(action: .auth(action: .fetchError(error: nil))) }
        )
        
        return VStack {
            TextField("Email", text: $login)
                //.keyboardType(.namePhonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                //.keyboardType(.namePhonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Button {
                withAnimation {
                    store.dispatch(action: .auth(action: .logIn(login: login, password: password)))
                }
            } label: {
                Text("Log in")
                    .font(.title)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.lightText)
                    .cornerRadius(10)
            }
            .padding()
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
//            Button {
//                withAnimation {
//                    store.dispatch(action: .auth(action: .googleLogIn))
//                }
//            } label: {
//                GoogleButton()
//                    .colorScheme(colorScheme == .dark ? .dark : .light)
//                    .style(.standard)
//                    .frame(width: 120, height: 50)
//                    .padding()
//            }
        }
        .alert(isPresented: shouldDisplayError) {
            Alert(
                title: Text("Login Failed"),
                message: Text(store.state.auth.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeLoginView()
    }
}
