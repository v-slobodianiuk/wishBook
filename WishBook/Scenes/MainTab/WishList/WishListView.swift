//
//  WishListView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct WishListView<VM: WishListViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    @State private var wishDetailsIsPresented = false
    
    var body: some View {
        VStack(alignment: .leading) {
            listView()
        }
        .onAppear {
            vm.getData()
        }
        .navigationBarTitle("WISH_LIST_NAV_TITLE".localized)
        .navigationBarItems(trailing: setupTrailingNavBarItems())
        .sheet(isPresented: $wishDetailsIsPresented, content: {
            vm.router.showWishDetails()
        })
    }
    
    fileprivate func listView() -> some View {
        List {
            ForEach(vm.wishList) { item in
                Text(item.title)
            }
            .onDelete(perform: { indexSet in
                guard let index = indexSet.first else { return }
                vm.deleteItem(id: vm.wishList[index].id)
            })
        }
    }
    
    fileprivate func setupTrailingNavBarItems() -> some View {
        HStack {
            Button(action: {
                wishDetailsIsPresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.selectedTabItem)
                    Text("WISH_ITEM_ADD_BUTTON_TITLE".localized)
                }
            })
        }
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        WishListView(vm: WishListViewModel(router: WishListRouter(), repository: WishListRepository()))
    }
}
