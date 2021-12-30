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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        return NavigationView {
            ZStack {
                if store.state.wishes.fetchInProgress {
                    ProgressView()
                } else {
                    VStack(alignment: .leading) {
                        listView
                    }
                }
            }
            .navigationBarTitle("WISH_LIST_NAV_TITLE".localized)
            .navigationBarItems(trailing: setupTrailingNavBarItems)
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    fileprivate var listView: some View {
        List {
            ForEach(store.state.wishes.wishList.indices, id: \.self) { index in
                ZStack {
                    if index == store.state.wishes.getLastIndexItem() && store.state.wishes.paginationInProgress {
                        ProgressView()
                    } else {
                        Text(store.state.wishes.wishList[index].title)
                            .onTapGesture {
                                store.dispatch(action: .wishes(action: .prepareWishDetailsFor(index: index)))
                                wishDetailsIsPresented.toggle()
                            }
                    }
                }
                .onAppear {
                    if index == store.state.wishes.getLastIndexItem() {
                        guard !store.state.wishes.fullDataLoadingCompleted else { return }
                        withAnimation {
                            store.dispatch(action: .wishes(action: .fetchMore))
                        }
                    }
                }
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
            screenFactory.makeWishDetailsView(isEditable: true)
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
            screenFactory.makeWishDetailsView(isEditable: true)
        }
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        WishListView()
    }
}
