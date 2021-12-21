//
//  WishesReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

func wishesReducer(state: inout WishesState, action: WishesAction) -> Void {
    switch action {
    case .fetch:
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
    case .selectItem(let selectedItem):
        state.selectedItem = selectedItem
    case .discardSelection:
        state.selectedItem = nil
    default:
        break
    }
}
