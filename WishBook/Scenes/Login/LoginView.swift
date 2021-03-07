//
//  ContentView.swift
//  WishBook
//
//  Created by Vadym on 22.02.2021.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    
    var body: some View {
        VStack {
            GoogleButton()
                .colorScheme(.light)
                .frame(width: 120, height: 50)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
