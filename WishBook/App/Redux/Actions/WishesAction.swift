//
//  WishesAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

enum WishesAction {
    case fetch(_ limit: Int?)
    case fetchComplete(data: [WishListModel])
    case fetchError(error: String?)
    case selectItem(_ item: Int)
    case deleteItem(id: String?)
    case discardSelection
    case updateWishListWithItem(title: String, description: String?, url: String?)
    case fetchMore
    case fetchMoreComplete(data: [WishListModel])
}
