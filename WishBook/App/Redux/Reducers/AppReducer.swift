//
//  AppReducer.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

func appReducer(state: inout AppState, action: AppAction) -> Void {
    switch action {
    case .auth(let authAction):
        authReducer(state: &state.auth, action: authAction)
    case .profile(let profileAction):
        profileReducer(state: &state.profile, action: profileAction)
    case .wishes(let wishesAction):
        wishesReducer(state: &state.wishes, action: wishesAction)
    case .people(let peopleAction):
        peopleReducer(state: &state.people, action: peopleAction)
    case .clearData:
        state.profile = ProfileState()
        state.wishes = WishesState()
        state.people = PeopleState()
    }
}
