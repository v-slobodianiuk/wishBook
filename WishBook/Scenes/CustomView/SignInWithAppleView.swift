//
//  SignInWithAppleView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.01.2022.
//

import SwiftUI
import AuthenticationServices
import SDWebImageSwiftUI

typealias AppleSignInResult = (_ result: Result<ASAuthorization, Error>, _ nonce: String?) -> Void

struct SignInWithAppleView: UIViewRepresentable {
    private let authorizationButton: ASAuthorizationAppleIDButton
    private let completion: AppleSignInResult

    init(
        type: ASAuthorizationAppleIDButton.ButtonType,
        style: ASAuthorizationAppleIDButton.Style,
        completion: @escaping AppleSignInResult
    ) {
        self.authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
        self.completion = completion
    }

    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        authorizationButton.addTarget(context.coordinator, action: #selector(Coordinator.handleAuthorizationAppleIDButton), for: .touchUpInside)
        return authorizationButton
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, completion: completion)
    }

    final class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

        private let parent: SignInWithAppleView
        private let completion: AppleSignInResult
        private var currentNonce: String?

        init(_ parent: SignInWithAppleView, completion: @escaping AppleSignInResult) {
            self.parent = parent
            self.completion = completion
        }

        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            (UIApplication.shared.windows.first?.rootViewController?.view.window!)!
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            completion(.success(authorization), currentNonce)
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            completion(.failure(error), nil)
        }

        @objc
        func handleAuthorizationAppleIDButton() {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let nonce = CryptoService.randomNonceString()
            currentNonce = nonce

            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = CryptoService.sha256(nonce)

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension SignInWithAppleView {
    func customCornerRadius(_ radius: CGFloat) -> Self {
        authorizationButton.cornerRadius = radius
        return self
    }
}
