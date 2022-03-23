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

    // MARK: - body
    var body: some View {
        let shouldDisplayError = Binding<Bool>(
            get: { store.state.auth.errorMessage != nil },
            set: { _ in store.dispatch(action: .auth(action: .fetchError(error: nil))) }
        )

        let shouldDisplayPasswordResetSuccess = Binding<Bool>(
            get: { store.state.auth.successfullyPaswordReset },
            set: { _ in store.dispatch(action: .auth(action: .resetPasswordComplete(success: false))) }
        )
        NavigationView {
            if store.state.auth.fetchInProgress {
                ProgressView()
            } else {
                ZStack {
                    contentView
                        .frame(maxHeight: .infinity)
                        .alert(isPresented: shouldDisplayError) {
                            Alert(
                                title: Text("FAIL_TITLE".localized),
                                message: Text(store.state.auth.errorMessage ?? ""),
                                dismissButton: .default(Text("OK_ACTION_TITLE".localized))
                            )
                        }

                    if passwordPromptIsPresented {
                        PasswordPromptView(isPresented: $passwordPromptIsPresented)
                    }

                    if store.state.auth.successfullyPaswordReset {
                        ResetPasswordView(isPresented: shouldDisplayPasswordResetSuccess)
                    }
                }
                .navigationTitle("LOGIN_TITLE".localized)
            }
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Content View
    fileprivate var contentView: some View {
        VStack(alignment: .leading) {
            inputView

            buttonsView

            Link("PRIVACY_POLICY_TEXT".localized, destination: URL(string: "PRIVACY_POLICY_URL".localized)!)
                .font(Font.footnote)
                .foregroundColor(.gray)
                .padding([.horizontal, .top])
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    // MARK: - Input view
    fileprivate var inputView: some View {
        Group {
            TextField("EMAIL_PLACEHOLDER".localized, text: $email) {
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
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .padding([.horizontal, .top])

            Divider()
                .padding(.horizontal)

            if !isValidEmail && !email.isEmpty {
                WarningText(text: "EMAIL_ERROR".localized)
                    .padding(.horizontal)
                    .lineLimit(.max)
            }

            SecureField("PASSWORD_PLACEHOLDER".localized, text: $password) {
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
            .padding([.horizontal, .top])

            Divider()
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
                            .foregroundColor(.red)
                        WarningText(text: "PASSWORD_ERROR".localized)
                    }
                }
                .padding(.leading)
            }
        }
    }

    // MARK: - Buttons View
    fileprivate var buttonsView: some View {
        Group {
            if isValidEmail {
                Button {
                    endEditing()
                    withAnimation {
                        store.dispatch(action: .auth(action: .resetPassword(email: email)))
                    }
                } label: {
                    Text("RESET_PASSWORD_TITLE".localized)
                        .foregroundColor(.main)
                        .padding([.horizontal])
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }

            Button("LOGIN_BUTTON_TITLE".localized) {
                withAnimation {
                    store.dispatch(action: .auth(action: .logIn(login: email, password: password)))
                }
            }
            .buttonStyle(ConfirmButtonStyle())
            .opacity(!(isValidEmail && isValidPassword) ? 0.5 : 1.0)
            .disabled(!(isValidEmail && isValidPassword))
            .padding([.horizontal, .top])

            Text("DIVIDER_TEXT".localized)
                .font(Font.footnote)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)

            Button {
                withAnimation {
                    store.dispatch(action: .auth(action: .googleLogIn))
                }
            } label: {
                Label {
                    Text("GOOGLE_BUTTON_TITLE".localized)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundColor(.light)
                } icon: {
                    Image("btn_google_light_normal_ios")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.label)
            .cornerRadius(10)
            .padding(.horizontal)

            SignInWithAppleView(type: .continue, style: colorScheme == .dark ? .white : .black) { result, nonce in
                guard let nonce = nonce else {
                    // Invalid state: A login callback was received, but no login request was sent.
                    return
                }
                store.dispatch(action: .auth(action: .sighInWithApple(nonce: nonce, result: result)))
            }
            .customCornerRadius(10)
            .frame(height: 50)
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeLoginView()
            // .preferredColorScheme(.dark)
    }
}
