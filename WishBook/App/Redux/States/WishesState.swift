//
//  WishesState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

struct WishesState {
    var wishList = [WishListModel]()
    var fetchInProgress: Bool = false
    var paginationInProgress: Bool = false
    var paginationCompleted: Bool = false
    var paginationLimit: Int = 20
    var errorMessage: String?
    var selectedItem: Int?
    var itemIdForDelete: String?
    
    func getLastIndexItem() -> Int {
        wishList.count - 1
    }
}
