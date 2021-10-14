//
//  UserPageRouter.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 14.10.2021.
//

import SwiftUI

protocol UserPageRouterProtocol: WishListRouterProtocol {

}

final class UserPageRouter: UserPageRouterProtocol {
    func showWishDetails(wishItem: WishListModel?) -> AnyView {
        let wishDetailsView = WishDetailsModuleBuilder.create(wishItem: wishItem)
        return AnyView(wishDetailsView)
    }
}
