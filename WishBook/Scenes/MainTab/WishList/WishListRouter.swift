//
//  WishListRouter.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

protocol WishListRouterProtocol {
    func showWishDetails(wishItem: WishListModel?) -> AnyView
}

extension WishListRouterProtocol {
    func showWishDetails(wishItem: WishListModel?) -> AnyView {
        let wishDetailsView = WishDetailsModuleBuilder().create(wishItem: wishItem)
        return AnyView(wishDetailsView)
    }
}

final class WishListRouter: WishListRouterProtocol {

}
