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
        middlewarePublisher { (promise: @escaping (Result<AppAction, MiddlewareError>) -> Void) in
            switch action {
            case .wishes(action: .fetch(limit: let limit)):
                guard (limit != nil) || state.wishes.wishList.isEmpty else {
                    promise(.failure(.noAction))
                    return
                }
                
                service.loadData(limit: limit != nil ? (limit ?? 20) : 20)
                    //.print("Fetch wishes")
                    .subscribe(on: DispatchQueue.global())
                    .map { (data: [WishListModel]) -> AppAction in
                        return AppAction.wishes(action: .fetchComplete(data: data))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                    .sink { (action: AppAction) in
                        promise(.success(action))
                    }
                    .cancel()
                
            case .wishes(action: .fetchMore):
                print("action: .fetchMore: \(Thread.current)")
                service.loadMore()
                    //.print("Fetch more wishes")
                    .subscribe(on: DispatchQueue.global())
                    .delay(for: .seconds(0.24), scheduler: DispatchQueue.main)
                    .map { (data: [WishListModel]) -> AppAction in
                        print(".fetchMore .map: \(Thread.current)")
                        return AppAction.wishes(action: .fetchMoreComplete(data: data))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .sink { (action: AppAction) in
                        print(".fetchMore .sink: \(Thread.current)")
                        promise(.success(action))
                    }
                    .cancel()
            case .wishes(action: .deleteItem(let id)):
                guard let id = id else {
                    promise(.failure(.noAction))
                    return
                }
                
                service.delete(id: id)
                    .print("Remove wish")
                    .subscribe(on: DispatchQueue.global())
                    .map { (_) -> AppAction in
                        return AppAction.wishes(action: .fetch(limit: state.wishes.wishList.count))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .sink { (action: AppAction) in
                        promise(.success(action))
                    }
                    .cancel()
            case .wishes(action: .updateWishListWithItem(let title,let description, let url)):
                var publisher: Publishers.Print<AnyPublisher<WishListModel, Error>>
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
                
                publisher
                    .map { (_) -> AppAction in
                        return AppAction.wishes(action: .fetch(limit: state.wishes.wishList.count + 1))
                    }
                    .catch { (error: Error) -> Just<AppAction> in
                        return Just(AppAction.wishes(action: .fetchError(error: error.localizedDescription)))
                    }
                    .sink { (action: AppAction) in
                        promise(.success(action))
                    }
                    .cancel()
            default:
                promise(.failure(.noAction))
            }
        }
    }
}
