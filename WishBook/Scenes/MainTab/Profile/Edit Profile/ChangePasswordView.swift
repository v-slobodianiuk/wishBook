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

    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isValidPassword: Bool = false
    @State private var passwordPromptIsPresented: Bool = false
    @State private var closeButtonIsPresented: Bool = true

    // MARK: - body
    var body: some View {
        let shouldDisplayError = Binding<Bool>(
            get: { store.state.auth.errorMessage != nil },
            set: { _ in store.dispatch(action: .auth(action: .fetchError(error: nil))) }
        )

        if store.state.auth.fetchInProgress {
            ProgressView()
        } else {
            if store.state.auth.successfullyPaswordChanged {
                successView
            } else {
                contentView
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .resignKeyboardOnTapGesture {
                        guard !closeButtonIsPresented else { return }
                        withAnimation { closeButtonIsPresented = true }
                    }
                    .alert(isPresented: shouldDisplayError) {
                        return Alert(
                            title: Text("FAIL_TITLE".localized),
                            message: Text(store.state.auth.errorMessage ?? ""),
                            dismissButton: .default(Text("OK_ACTION_TITLE".localized))
                        )
                    }
            }
        }
    }

    // MARK: - Content View
    fileprivate var contentView: some View {
        ZStack {
            VStack {
                Spacer()

                Image(systemName: "lock.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.main)
                    .opacity(0.2)

                Spacer()

                Text("CREATE_NEW_PASSWORD_TITLE".localized)
                    .font(Font.title)
                    .foregroundColor(.label)

                VStack(alignment: .leading) {
                    textFieldsView

                    if password != confirmPassword {
                        WarningText(text: "PASSWORD_WARNING_TEXT".localized)
                    }
                }

                Button("CONFIRM_BUTTON_TITLE".localized) {
                    withAnimation {
                        store.dispatch(action: .auth(action: .updatePassword(password: password)))
                    }
                }
                .opacity(!isValidPassword ? 0.5 : 1.0)
                .disabled(!isValidPassword)
                .buttonStyle(ConfirmButtonStyle())
                .padding(.vertical)

                Spacer()

                if closeButtonIsPresented {
                    closeButtonView
                }
            }
            .padding(.horizontal)

            if passwordPromptIsPresented {
                PasswordPromptView(isPresented: $passwordPromptIsPresented)
            }
        }
    }

    // MARK: - TextFields
    fileprivate var textFieldsView: some View {
        Group {
            SecureField("PASSWORD_PLACEHOLDER".localized, text: $password) {
                withAnimation {
                    let isValid = store.state.auth.isValidPassword(password)
                    isValidPassword = (password == confirmPassword && isValid)

                    guard !closeButtonIsPresented else { return }
                    closeButtonIsPresented = true
                }
            }
            .onChange(of: password) { currentText in
                withAnimation {
                    password = currentText.removeWrongCharacters()
                    let isValid = store.state.auth.isValidPassword(currentText)
                    isValidPassword = (password == confirmPassword && isValid)
                }
            }
            .onTapGesture {
                guard closeButtonIsPresented else { return }
                withAnimation { closeButtonIsPresented = false }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())

            if !store.state.auth.isValidPassword(password) && !password.isEmpty {
                Button {
                    endEditing()
                    closeButtonIsPresented = true
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
            }

            SecureField("REPEAT_PASSWORD_PLACEHOLDER".localized, text: $confirmPassword) {
                withAnimation {
                    let isValid = store.state.auth.isValidPassword(confirmPassword)
                    isValidPassword = (password == confirmPassword && isValid)

                    guard !closeButtonIsPresented else { return }
                    closeButtonIsPresented = true
                }
            }
            .onChange(of: confirmPassword) { currentText in
                withAnimation {
                    confirmPassword = currentText.removeWrongCharacters()
                    let isValid = store.state.auth.isValidPassword(currentText)
                    isValidPassword = (password == confirmPassword && isValid)
                }
            }
            .onTapGesture {
                guard closeButtonIsPresented else { return }
                withAnimation { closeButtonIsPresented = false }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }

    // MARK: - Close Button
    fileprivate var closeButtonView: some View {
        Button {
            store.dispatch(action: .auth(action: .updatePasswordComplete(isChanged: false)))
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.main)
        }
        .padding()
    }

    // MARK: - Success View
    fileprivate var successView: some View {
        VStack {
            Spacer()

            Image(systemName: "checkmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundColor(.main)
                .opacity(0.2)

            Text("SUCCESS_TITLE".localized)
                .font(Font.largeTitle)
                .foregroundColor(.label)
                .padding()

            Spacer()

            closeButtonView
        }
        .transition(.asymmetric(insertion: AnyTransition.flipFromBottom(duration: 0.24), removal: .opacity))
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeChangePasswordView()
            // .preferredColorScheme(.dark)
    }
}
