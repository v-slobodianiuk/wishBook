//
//  GoogleButton.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI
import GoogleSignIn

struct GoogleButton: UIViewRepresentable {
    
    fileprivate let googleButton = GIDSignInButton()
    
    func makeUIView(context: UIViewRepresentableContext<GoogleButton>) -> GIDSignInButton {
        return googleButton
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleButton>) {
        
    }
    
    func colorScheme(_ color: GIDSignInButtonColorScheme) -> Self {
        googleButton.colorScheme = color
        return self
    }
    
    func style(_ style: GIDSignInButtonStyle) -> Self {
        googleButton.style = style
        return self
    }
    
}
