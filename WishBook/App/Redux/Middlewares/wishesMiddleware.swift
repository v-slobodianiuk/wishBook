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
        case .wishes(action: .fetch):
            guard state.wishes.wishList.isEmpty else {
                return Empty().eraseToAnyPublisher()
            }
            
            let publisher = service.wishesSubject()
            service.loadData(limit: state.wishes.wishList.isEmpty ? 20 : state.wishes.wishList.count + 1)
            return publisher
                .print("Fetch wishes")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.global())
                .removeDuplicates()
                .map {
                    return AppAction.wishes(action: .fetchComplete(data: $0))
                }
                .eraseToAnyPublisher()
        case .wishes(action: .fetchMore):
            return service.loadMore()
                .print("Fetch more wishes")
                .subscribe(on: DispatchQueue.global())
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.global())
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
            
            service.removeListener()
            return service.delete(id: id)
                .print("Remove wish")
                .subscribe(on: DispatchQueue.global())
                .map { _ in
                    AppAction.wishes(action: .fetch)
                }
                .catch { error in
                    Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                }
                .eraseToAnyPublisher()
        case .wishes(action: .updateWishListWithItem(let title,let description, let url)):
            let publisher: Publishers.Print<AnyPublisher<WishListModel, Error>>
            var wish: WishListModel
            service.removeListener()
            
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
                .delay(for: .seconds(0.24), scheduler: DispatchQueue.global())
                .map { _ in
                    return AppAction.wishes(action: .fetch)
                }
                .catch { Just(AppAction.wishes(action: .fetchError(error: $0.localizedDescription))) }
                .eraseToAnyPublisher()
        default:
            break
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
