//
//  WishListView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct WishListView: View {
    
    @EnvironmentObject var store: AppStore
    @State private var wishDetailsIsPresented: Bool = false
    @State private var createNewWishIsPresented: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            if store.state.wishes.fetchInProgress {
                ProgressView()
            } else {
                listView
            }
        }
        .navigationBarTitle("WISH_LIST_NAV_TITLE".localized)
        .navigationBarItems(trailing: setupTrailingNavBarItems)
    }
    
    @ViewBuilder
    fileprivate var listView: some View {
        List {
            ForEach(store.state.wishes.wishList.indices, id: \.self) { index in
                WishCellView(
                    title: store.state.wishes.wishList[index].title,
                    currentIndex: index,
                    lastIndexItem: store.state.wishes.getLastIndexItem(),
                    paginationInProgress: store.state.wishes.paginationInProgress,
                    fullLoadingComplete: store.state.wishes.fullDataLoadingCompleted,
                    loadingAction: {
                        store.dispatch(action: .wishes(action: .prepareWishDetailsFor(index: index)))
                        wishDetailsIsPresented.toggle()
                    }, prepareAction: {
                        store.dispatch(action: .wishes(action: .fetchMore))
                    }
                )
            }
            .onDelete { indexSet in
                guard let index = indexSet.first else { return }
                store.dispatch(action: .wishes(action: .deleteItem(id: store.state.wishes.wishList[index].id)))
            }
        }
        .onAppear {
            withAnimation {
                store.dispatch(action: .wishes(action: .fetch(limit: nil)))
            }
        }
        .sheet(isPresented: $wishDetailsIsPresented) {
            screenFactory.makeWishDetailsView()
                .wishState(.editable)
        }
    }
    
    @ViewBuilder
    fileprivate var setupTrailingNavBarItems: some View {
        HStack {
            Button(action: {
                createNewWishIsPresented.toggle()
            }, label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                    Text("WISH_ITEM_ADD_BUTTON_TITLE".localized)
                        .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
                }
            })
        }
        .sheet(isPresented: $createNewWishIsPresented) {
            screenFactory.makeWishDetailsView()
                .wishState(.new)
        }
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeWishListView()
    }
}
