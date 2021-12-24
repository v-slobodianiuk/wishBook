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
    return { (state: AppState, action: AppAction) -> AnyPublisher<AppAction, Never> in
        switch action {
        case .people(action: .fetch(let searchText)):
            return service.searchData(key: searchText, limit: 20)
                .print("Search People")
                .subscribe(on: DispatchQueue.global())
                .map { (data: [ProfileModel]) -> AppAction in
                    return AppAction.people(action: .fetchComplete(data: data))
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                }
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .people(action: .fetchMore):
            return service.loadMore()
                .print("Fetch more search result")
                .subscribe(on: DispatchQueue.global())
                .map { (data: [ProfileModel]) -> AppAction in
                    return AppAction.people(action: .fetchMoreComplete(data: data))
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.people(action: .fetchError(error: error.localizedDescription)))
                }
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        default:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}
