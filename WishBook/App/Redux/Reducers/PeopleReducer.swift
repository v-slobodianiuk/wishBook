//
//  PeopleReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation

func peopleReducer(state: inout PeopleState, action: PeopleAction) -> Void {
    switch action {
    case .fetch:
        if state.peopleList.isEmpty {
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
    }
}
