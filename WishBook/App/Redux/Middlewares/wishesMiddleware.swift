//
//  wishesMiddleware.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 18.12.2021.
//

import ReduxCore
import Foundation
import Combine

func wishesMiddleware(service: WishListServiceProtocol) -> Middleware<AppState, AppAction> {
    return { (state: AppState, action: AppAction) -> AnyPublisher<AppAction, Never> in
            switch action {
            case .wishes(action: .fetch(limit: let limit)):
                guard (limit != nil) || state.wishes.wishList.isEmpty else {
                    return Empty().eraseToAnyPublisher()
                }

                return service.loadData(userId: UserStorage.profileUserId, limit: limit != nil ? (limit ?? 20) : 20)
                    //.print("Fetch wishes")
                    .subscribe(on: DispatchQueue.global())
                    .map { (data: [WishListModel]) -> AppAction in
                        print(".fetch .map: \(Thread.current)")
                        return AppAction.wishes(action: .fetchComplete(data: data))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            case .wishes(action: .fetchMore):
                return service.loadMore(userId: UserStorage.profileUserId)
                    //.print("Fetch more wishes")
                    .subscribe(on: DispatchQueue.global())
                    .map { (data: [WishListModel]) -> AppAction in
                        print(".fetchMore .map: \(Thread.current)")
                        return AppAction.wishes(action: .fetchMoreComplete(data: data))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            case .wishes(action: .deleteItem(let id)):
                guard let id = id else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return service.delete(id: id)
                    .print("Remove wish")
                    .subscribe(on: DispatchQueue.global())
                    .map { (_) -> AppAction in
                        return AppAction.wishes(action: .fetch(limit: state.wishes.wishList.count))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .eraseToAnyPublisher()
            case .wishes(action: .updateWishListWithItem(let title,let description, let url)):
                var publisher: Publishers.Print<AnyPublisher<WishListModel, Error>>
                var wish: WishListModel
                
                if var selectedItem = state.wishes.wishDetails {
                    selectedItem.title = title
                    selectedItem.description = description
                    selectedItem.url = url
                    publisher = service.updateData(selectedItem)
                        .print("Update wish")
                } else {
                    wish = WishListModel(title: title, description: description, url: url)
                    publisher = service.addData(wish)
                        .print("Add wish")
                }
                
                return publisher
                    .subscribe(on: DispatchQueue.global())
                    .map { (_) -> AppAction in
                        return AppAction.wishes(action: .fetch(limit: state.wishes.wishList.count + 1))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .eraseToAnyPublisher()
            default:
                break
            }
        
        return Empty().eraseToAnyPublisher()
    }
}
