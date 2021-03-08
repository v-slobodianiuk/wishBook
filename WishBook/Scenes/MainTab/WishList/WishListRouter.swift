//
//  WishListRouter.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

protocol WishListRouterProtocol {
    func showWishDetails() -> AnyView
}

final class WishListRouter: WishListRouterProtocol {
    func showWishDetails() -> AnyView {
        let wishDetailsView = WishDetailsModuleBuilder.create()
        return AnyView(wishDetailsView)
    }
}
