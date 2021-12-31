//
//  PeopleAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation

enum PeopleAction {
    case fetch(searchText: String)
    case fetchComplete(data: [ProfileModel])
    case fetchMore
    case fetchMoreComplete(data: [ProfileModel])
    case fetchError(error: String?)
    case clearSearch
    
    case prepareProfileDataFor(index: Int)
    
    case fetchWishes(limit: Int?)
    case fetchWishesComplete(data: [WishListModel])
    case fetchWishesMore
    case fetchWishesMoreComplete(data: [WishListModel])
    case clearSearchedProfileData
    
    case prepareWishDetailsFor(index: Int)
    
    case subscribe
    case unsubscribe
    case updateSearchedProfileDataBy(id: String)
    case updateSearchedProfileDataComplete(data: ProfileModel)
    
    case subscribersList(data: ProfileModel)
    case subscriptionsList(data: ProfileModel)
}
