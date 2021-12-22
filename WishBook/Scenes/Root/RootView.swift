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
                screenFactory.makeMainTabBar()
            } else {
                screenFactory.makeLoginView()
            }
        }
        .onAppear {
            store.dispatch(action: .auth(action: .fetch))
        }
    }
}
