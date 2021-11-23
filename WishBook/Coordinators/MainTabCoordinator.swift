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
    func setupPeopleTabItem() -> FriendsView
    func setupWishListTabItem() -> WishListView
    func setupProfileView() -> Profile
}

final class MainTabCoordinator: MainTabCoordinatorProtocol {
    
    func start() {
        
    }
    
    func setupPeopleTabItem() -> some View {
        let friendsNavigatedView = NavigationView { PeopleModuleBuilder().create() }
        return friendsNavigatedView
    }
    
    func setupWishListTabItem() -> some View {
        let wishListNavigatedView = NavigationView { WishListModuleBuilder.create() }
        return wishListNavigatedView
    }
    
    func setupProfileView() -> some View {
        let profileNavigatedView = NavigationView { ProfileModuleBuilder.create() }
        return profileNavigatedView
    }
}
