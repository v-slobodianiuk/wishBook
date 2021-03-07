//
//  WishListModuleBuilder.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

enum WishListModuleBuilder {
    static func create() -> some View {
        let vm = WishListViewModel()
        let wishListView = WishListView(vm: vm)
        return wishListView
    }
}
