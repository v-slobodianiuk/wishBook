//
//  WishListView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct WishListView<VM: WishListViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    
    var body: some View {
        Text("WishList View")
            .navigationBarTitle("WISH_LIST_NAV_TITLE".localized)
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        WishListView(vm: WishListViewModel())
    }
}
