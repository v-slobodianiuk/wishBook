//
//  RootView.swift
//  WishBook
//
//  Created by Vadym on 27.02.2021.
//

import SwiftUI
import Firebase

struct RootView: View {
    
    @State private var isLoggedIn = UserStorage.isLoggedIn
    
    let coordinator: RootCoordinatorProtocol
    
    var body: some View {
        Group {
            isLoggedIn ? coordinator.showManTabView() : coordinator.showLoginView()
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { (_, user) in
                UserStorage.isLoggedIn = user != nil
                isLoggedIn = user != nil
            }
        }
    }
}
