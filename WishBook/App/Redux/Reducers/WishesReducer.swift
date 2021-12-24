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
        if state.wishList.isEmpty {
            state.fetchInProgress = true
        }
    case .fetchMore:
        state.paginationInProgress = true
    case .fetchComplete(let data):
        state.wishList = data
        state.fetchInProgress = false
    case .fetchMoreComplete(let data):
        guard !data.isEmpty else {
            state.paginationCompleted = true
            state.paginationInProgress = false
            return
        }
        state.wishList += data
    case .fetchError(let message):
        if let errorMessage = message {
            state.errorMessage = errorMessage
        }
        state.fetchInProgress = false
    case .prepareWishDetailsFor(let index):
        state.wishDetails = state.wishList[index]
    default:
        break
    }
}
