//
//  PeopleReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation

func peopleReducer(state: inout PeopleState, action: PeopleAction) -> Void {
    switch action {
    case .fetch(let searchText):
        if searchText.count >= 3 {
            state.fetchInProgress = true
        }
    case .fetchMore:
        state.paginationInProgress = true
    case .fetchComplete(let data):
        state.peopleList = data
        state.fetchInProgress = false
    case .fetchMoreComplete(let data):
        guard !data.isEmpty else {
            state.paginationCompleted = true
            state.paginationInProgress = false
            return
        }
        state.peopleList += data
    case .fetchError(let message):
        if let errorMessage = message {
            state.errorMessage = errorMessage
        }
        state.fetchInProgress = false
    case .prepareProfileDataFor(let index):
        state.searchedProfile = state.peopleList[index]
        state.searchedProfileWishes.removeAll()
        
    case .fetchWishes(limit: _):
        if state.searchedProfileWishes.isEmpty && !state.wishesFullDataLoadingCompleted {
            state.wishesFetchInProgress = true
        }
    case .fetchWishesMore:
        if !state.wishesFullDataLoadingCompleted {
            state.wishesPaginationInProgress = true
        }
    case .fetchWishesComplete(let data):
        if data.count < state.paginationLimit {
            state.wishesFullDataLoadingCompleted = true
        }
        
        state.searchedProfileWishes = data
        state.wishesFetchInProgress = false
    case .fetchWishesMoreComplete(let data):
        guard !data.isEmpty else {
            state.wishesFullDataLoadingCompleted = true
            state.wishesPaginationInProgress = false
            return
        }
        state.searchedProfileWishes += data
    case .clearSearchedProfileData:
        state.searchedProfileWishes.removeAll()
    case .prepareWishDetailsFor(let index):
        state.searchedProfileWishDetails = state.searchedProfileWishes[index]
    case .updateSearchedProfileDataBy(id: _):
        state.subscribeIsDisabled = true
    case .updateSearchedProfileDataComplete(let data):
        state.searchedProfile = data
        state.subscribeIsDisabled = false
    default:
        break
    }
}
