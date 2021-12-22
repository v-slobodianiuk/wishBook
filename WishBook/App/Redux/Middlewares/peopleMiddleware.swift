//
//  peopleMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import ReduxCore
import Foundation
import Combine

func peopleMiddleware(service: PeopleServiceProtocol) -> Middleware<AppState, AppAction> {
    return { state, action in
        switch action {
        case .people(action: .fetch(let searchText)):
            return service.searchData(key: searchText, limit: 20)
                .print("Search People")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .map {
                    return AppAction.people(action: .fetchComplete(data: $0))
                }
                .catch { error in
                    Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        case .people(action: .fetchMore):
            return service.loadMore()
                .print("Fetch more search result")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .map {
                    return AppAction.people(action: .fetchMoreComplete(data: $0))
                }
                .catch { error in
                    Just(AppAction.people(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        default:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}
