//
//  ProfileReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

func profileReducer(state: inout ProfileState, action: ProfileAction) -> Void {
    switch action {
    case .fetch:
        if state.profileData == nil {
            state.fetchInProgress = true
        }
    case .fetchComplete(let profileData):
        state.profileData = profileData
        state.haveFullName = profileData.firstName != nil
        state.fetchInProgress = false
    case .fetchError(let error):
        state.fetchInProgress = false
        state.errorMessage = error
    case .profileUpdated(let updatedProfile):
        state.profileData = updatedProfile
    default:
        break
    }
}
