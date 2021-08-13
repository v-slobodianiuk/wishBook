//
//  ContentView.swift
//  WishBook
//
//  Created by Vadym on 22.02.2021.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView<VM: LoginViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    
    var body: some View {
        VStack {
            TextField("Email", text: $vm.loginModel.email)
                .keyboardType(.namePhonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Password", text: $vm.loginModel.password)
                .keyboardType(.namePhonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
//                .background(Color.orange)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .padding()
            Button {
                vm.loginPressed()
            } label: {
                Text("Log in")
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.selectedTabItem)
                    .foregroundColor(.lightText)
                    .cornerRadius(10)
            }
            .padding()
            Button {
                vm.signInPressed()
            } label: {
                GoogleButton()
                    .colorScheme(.light)
                    .style(.standard)
                    .frame(width: 120, height: 50)
                    .padding()
            }
        }
        .alert(isPresented: $vm.showWarning) {

            Alert(title: Text("Login Failed"),
                  message: Text("\(vm.error ?? "")"),
                  dismissButton: .default(Text("OK"), action: {
                    vm.showWarning = false
                  }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(vm: LoginViewModel(googleAuthService: DI.getGoogleAuthService(), repository: DI.getProfileRepository()))
    }
}
