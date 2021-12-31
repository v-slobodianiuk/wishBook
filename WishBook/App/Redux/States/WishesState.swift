//
//  WishesState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

struct WishesState {
    var wishList = [WishListModel]()
    var wishDetails: WishListModel?
    
    var fetchInProgress: Bool = false
    var paginationInProgress: Bool = false
    var fullDataLoadingCompleted: Bool = false
    
    var errorMessage: String? = nil
    var itemIdForDelete: String? = nil
    
    var paginationLimit: Int = 20
    
    func getLastIndexItem() -> Int {
        wishList.count - 1
    }
}
