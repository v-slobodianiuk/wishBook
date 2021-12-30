//
//  peopleMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import ReduxCore
import Foundation
import Combine

func peopleMiddleware(service: PeopleServiceProtocol, profileService: ProfileServiceProtocol, wishesService: WishListServiceProtocol) -> Middleware<AppState, AppAction> {
    return { (state: AppState, action: AppAction) -> AnyPublisher<AppAction, Never> in
        switch action {
        case .people(action: .fetch(let searchText)):
            
            if let publisher = service.searchPublisher() {
                return publisher
                    .print("Search Publisher")
                    .subscribe(on: DispatchQueue.global())
                    .filter { searchText -> Bool in
                        return searchText.count == 3 || searchText.isEmpty
                    }
                    .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
                    .flatMap { searchText in
                        service.searchData(key: searchText)
                    }
                    .map { (data: [ProfileModel]) -> AppAction in
                        return AppAction.people(action: .fetchComplete(data: data))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .eraseToAnyPublisher()
            }
            
            service.sendSearchText(searchText.lowercased())
            
            if searchText.isEmpty {
                service.cancellPreviousSearch()
            }
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
                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .people(action: .fetchWishes(let limit)):
            guard (limit != nil) || state.people.searchedProfileWishes.isEmpty, let userId = state.people.searchedProfile?.id else {
                return Empty().eraseToAnyPublisher()
            }

            return wishesService.loadData(userId: userId, limit: limit != nil ? (limit ?? 20) : 20)
                //.print("Fetch wishes")
                .subscribe(on: DispatchQueue.global())
                .map { (data: [WishListModel]) -> AppAction in
                    print(".fetch .map: \(Thread.current)")
                    return AppAction.people(action: .fetchWishesComplete(data: data))
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.people(action: .fetchError(error: error.localizedDescription)))
                }
                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .people(action: .fetchWishesMore):
            guard let userId = state.people.searchedProfile?.id else {
                return Empty().eraseToAnyPublisher()
            }
            
            return wishesService.loadMore(userId: userId)
                //.print("Fetch more wishes")
                .subscribe(on: DispatchQueue.global())
                .map { (data: [WishListModel]) -> AppAction in
                    return AppAction.people(action: .fetchWishesMoreComplete(data: data))
                }
                .catch { (error: Error) -> Just<AppAction> in
                    return Just(AppAction.people(action: .fetchError(error: error.localizedDescription)))
                }
                .delay(for: .seconds(Globals.defaultAnimationDuration), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        default:
            break
        }
        return Empty().eraseToAnyPublisher()
    }
}
