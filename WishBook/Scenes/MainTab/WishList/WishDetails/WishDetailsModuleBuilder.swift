//
//  WishDetailsModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

struct WishDetailsModuleBuilder {
    func create(wishItem: WishListModel? = nil, readOnly: Bool) -> some View {
        let vm = WishDetailsViewModel(repository: DI.getWishListRepository(), wishItem: wishItem, readOnly: readOnly)
        let wishDetailsView = WishDetailsView(vm: vm)
        return wishDetailsView
    }
}
