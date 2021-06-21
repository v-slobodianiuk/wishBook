//
//  WishListView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct WishListView<VM: WishListViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    @State private var wishDetailsIsPresented: Bool = false
    @State private var createNewWishIsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            listView()
        }
        .onAppear {
            vm.getData()
        }
        .navigationBarTitle("WISH_LIST_NAV_TITLE".localized)
        .navigationBarItems(trailing: setupTrailingNavBarItems())
    }
    
    fileprivate func listView() -> some View {
        List {
            ForEach(vm.wishList.indices, id: \.self) { index in
                Text(vm.wishList[index].title)
                    .onTapGesture {
                        //itemIndex = index
                        vm.selectedItem = index
                        wishDetailsIsPresented.toggle()
                    }
            }
            .onDelete(perform: { indexSet in
                guard let index = indexSet.first else { return }
                vm.deleteItem(id: vm.wishList[index].id)
            })
        }
        .sheet(isPresented: $wishDetailsIsPresented) {
            vm.router.showWishDetails(wishItem: vm.wishList[vm.selectedItem])
        }
    }
    
    fileprivate func setupTrailingNavBarItems() -> some View {
        HStack {
            Button(action: {
                createNewWishIsPresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.selectedTabItem)
                    Text("WISH_ITEM_ADD_BUTTON_TITLE".localized)
                }
            })
        }
        .sheet(isPresented: $createNewWishIsPresented) {
            vm.router.showWishDetails(wishItem: nil)
        }
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        WishListView(vm: WishListViewModel(router: WishListRouter(), repository: WishListRepository()))
    }
}
