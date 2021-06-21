//
//  WishDetailsModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

enum WishDetailsModuleBuilder {
    static func create(wishItem: WishListModel? = nil) -> some View {
        let vm = WishDetailsViewModel(repository: DI.getWishListRepository(), wishItem: wishItem)
        let wishDetailsView = WishDetailsView(vm: vm)
        return wishDetailsView
    }
}
