//
//  MainTabCoordinator.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI
import Foundation

protocol MainTabCoordinatorProtocol: Coordinator {
    associatedtype FriendsView: View
    associatedtype WishListView: View
    associatedtype Profile: View
    func setupFriendsTabItem() -> FriendsView
    func setupWishListTabItem() -> WishListView
    func setupProfileView() -> Profile
}

final class MainTabCoordinator: MainTabCoordinatorProtocol {
    
    func start() {
        
    }
    
    func setupFriendsTabItem() -> some View {
        let friendsNavigatedView = NavigationView { PeopleModuleBuilder.create() }
            .navigationViewStyle(StackNavigationViewStyle())
        return friendsNavigatedView
    }
    
    func setupWishListTabItem() -> some View {
        let wishListNavigatedView = NavigationView { WishListModuleBuilder.create() }
            .navigationViewStyle(StackNavigationViewStyle())
        return wishListNavigatedView
    }
    
    func setupProfileView() -> some View {
        let profileNavigatedView = NavigationView { ProfileModuleBuilder.create() }
            .navigationViewStyle(StackNavigationViewStyle())
        return profileNavigatedView
    }
}
