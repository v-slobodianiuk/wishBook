//
//  AppAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

enum AppAction {
    case auth(action: AuthAction)
    case profile(action: ProfileAction)
    case wishes(action: WishesAction)
    case people(action: PeopleAction)
    case clearData
}
