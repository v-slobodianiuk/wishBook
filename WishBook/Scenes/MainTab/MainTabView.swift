//
//  MainTabView.swift
//  WishBook
//
//  Created by Vadym on 06.03.2021.
//

import SwiftUI

struct MainTabView<C: MainTabCoordinatorProtocol>: View {
    
    let coordinator: C
    @State private var tabItem = TabItems.wishListView
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabView(selection: $tabItem) {
            coordinator.setupPeopleTabItem()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("People")
                }
                .tag(TabItems.friendsView)
            
            coordinator.setupWishListTabItem()
                .tabItem {
                    Image(systemName: "list.triangle")
                    Text("Wish List")
                }
                .tag(TabItems.wishListView)
            
            coordinator.setupProfileView()
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
        }
    }
}

extension MainTabView {
    enum TabItems: Hashable {
        case friendsView, wishListView, profileView
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(coordinator: MainTabCoordinator())
    }
}
