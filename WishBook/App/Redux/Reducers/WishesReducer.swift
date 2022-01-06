//
//  WishesReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

func wishesReducer(state: inout WishesState, action: WishesAction) -> Void {
    switch action {
    case .fetch(limit: _):
        if state.wishList.isEmpty && !state.fullDataLoadingCompleted {
            state.fetchInProgress = true
        }
    case .fetchMore:
        if !state.fullDataLoadingCompleted {
            state.paginationInProgress = true
        }
    case .fetchComplete(let data):
        if data.count < state.paginationLimit {
            state.fullDataLoadingCompleted = true
        }
        
        state.wishList = data
        state.fetchInProgress = false
    case .fetchMoreComplete(let data):
        guard !data.isEmpty else {
            state.fullDataLoadingCompleted = true
            state.paginationInProgress = false
            return
        }
        state.wishList += data
    case .fetchError(let message):
        if let errorMessage = message {
            state.errorMessage = errorMessage
        }
        state.fetchInProgress = false
    case .updateWishListWithItem(title: _, description: _, url: _):
        state.fullDataLoadingCompleted = false
    case .deleteItem(id: _):
        state.fetchInProgress = true
        state.fullDataLoadingCompleted = state.wishList.count <= 1
    case .prepareWishDetailsFor(let index):
        state.wishDetails = state.wishList[index]
    case .clearWishDetails:
        state.wishDetails = nil
    }
}
