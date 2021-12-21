//
//  WishListRouter.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

protocol WishListRouterProtocol {
    func showWishDetails(wishItem: WishListModel?, readOnly: Bool) -> AnyView
}

extension WishListRouterProtocol {
    func showWishDetails(wishItem: WishListModel?, readOnly: Bool = false) -> AnyView {
        //let wishDetailsView = WishDetailsModuleBuilder().create(wishItem: wishItem, readOnly: readOnly)
        return AnyView(EmptyView())
    }
}

final class WishListRouter: WishListRouterProtocol {

}
