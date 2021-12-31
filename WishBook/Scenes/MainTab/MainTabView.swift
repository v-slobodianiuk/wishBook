//
//  MainTabView.swift
//  WishBook
//
//  Created by Vadym on 06.03.2021.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var store: AppStore
    @Environment(\.colorScheme) var colorScheme
    @State private var tabItem = TabItems.wishListView
    
    var body: some View {
        TabView(selection: $tabItem) {
            NavigationView {
                screenFactory.makePeopleView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("People")
            }
            .tag(TabItems.friendsView)
            
            NavigationView {
                screenFactory.makeWishListView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "list.triangle")
                Text("Wish List")
            }
            .tag(TabItems.wishListView)
            
            NavigationView {
                screenFactory.makeProfileView()
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("PROFILE_TAB_ITEM".localized)
            }
            .tag(TabItems.profileView)
        }
        .accentColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            store.dispatch(action: .profile(action: .fetch))
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeMainTabBar()
    }
}
