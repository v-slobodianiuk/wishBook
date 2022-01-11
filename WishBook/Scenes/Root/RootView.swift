//
//  RootView.swift
//  WishBook
//
//  Created by Vadym on 27.02.2021.
//

import SwiftUI
import Firebase

struct RootView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        Group {
            if store.state.auth.isLoggedIn {
                if store.state.profile.haveFullName {
                    screenFactory.makeMainTabBar()
                } else {
                    NavigationView {
                        screenFactory.makeEditProfileView()
                    }
                    .navigationViewStyle(.stack)
                }
            } else {
                screenFactory.makeLoginView()
            }
        }
        .onAppear {
            store.dispatch(action: .auth(action: .fetch))
        }
    }
}
