//
//  WishDetailsView.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

struct WishDetailsView<VM: WishDetailsViewModelProtocol>: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm: VM
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                TextField("WISH_ITEM_TITLE_PLACEHOLER".localized, text: $vm.wishItem.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
                Button(action: {
                    vm.saveData()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("EDIT_PROFILE_BUTTON_TITLE".localized)
                        .font(.title)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding()
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: setupTrailingNavBarItems())
            .onAppear {
                vm.loadWishItem()
            }
            .onDisappear {
                vm.saveData()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    fileprivate func setupTrailingNavBarItems() -> some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("WISH_ITEM_CLOSE_BUTTON_TITLE".localized)
                    .foregroundColor(.black)
            })
        }
    }
}

struct WishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WishDetailsView(vm: WishDetailsViewModel(repository: DI.getWishListRepository()))
    }
}
