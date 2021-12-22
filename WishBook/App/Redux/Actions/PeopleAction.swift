//
//  PeopleAction.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation

enum PeopleAction {
    case fetch(searchText: String)
    case fetchComplete(data: [ProfileModel])
    case fetchMore
    case fetchMoreComplete(data: [ProfileModel])
    case fetchError(error: String?)
}
