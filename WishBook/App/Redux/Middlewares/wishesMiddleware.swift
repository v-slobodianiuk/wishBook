//
//  wishesMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 18.12.2021.
//

import Combine
import ReduxCore
import Foundation

func wishesMiddleware(service: WishListServiceProtocol) -> Middleware<AppState, AppAction> {
    return { state, action in
        switch action {
        case .wishes(action: .fetch(let limit)):
            guard limit != nil || state.wishes.wishList.isEmpty else {
                return Empty().eraseToAnyPublisher()
            }

            return service.loadData(limit: limit != nil ? (limit ?? 20) : 20)
                //.print("Fetch wishes")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .map {
                    return AppAction.wishes(action: .fetchComplete(data: $0))
                }
                .catch { error in
                    Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        case .wishes(action: .fetchMore):
            return service.loadMore()
                //.print("Fetch more wishes")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                .map {
                    return AppAction.wishes(action: .fetchMoreComplete(data: $0))
                }
                .catch { error in
                    Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        case .wishes(action: .deleteItem(let id)):
            guard let id = id else {
                return Empty().eraseToAnyPublisher()
            }
            
            return service.delete(id: id)
                .print("Remove wish")
                .subscribe(on: DispatchQueue.global())
                .map { _ in
                    AppAction.wishes(action: .fetch(state.wishes.wishList.count))
                }
                .catch { error in
                    Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        case .wishes(action: .updateWishListWithItem(let title,let description, let url)):
            let publisher: Publishers.Print<AnyPublisher<WishListModel, Error>>
            var wish: WishListModel
            
            if let selectedItem = state.wishes.selectedItem {
                wish = state.wishes.wishList[selectedItem]
                wish.title = title
                wish.description = description
                wish.url = url
                publisher = service.updateData(wish)
                    .print("Update wish")
            } else {
                wish = WishListModel(title: title, description: description, url: url)
                publisher = service.addData(wish)
                    .print("Add wish")
            }

            return publisher
                .subscribe(on: DispatchQueue.global())
                .map { _ in
                    return AppAction.wishes(action: .fetch(state.wishes.wishList.count + 1))
                }
                .catch { Just(AppAction.wishes(action: .fetchError(error: $0.localizedDescription))) }
                .eraseToAnyPublisher()
        default:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
