//
//  WishesAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

enum WishesAction {
    case fetch(limit: Int?)
    case fetchComplete(data: [WishListModel])
    case fetchMore
    case fetchMoreComplete(data: [WishListModel])
    
    case fetchError(error: String?)
    
    case updateWishListWithItem(title: String, description: String?, url: String?)
    case deleteItem(id: String?)
    
    case prepareWishDetailsFor(index: Int)
    case clearWishDetails
}
