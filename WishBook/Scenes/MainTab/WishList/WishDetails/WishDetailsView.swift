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
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        TextField("WISH_ITEM_TITLE_PLACEHOLER".localized, text: $vm.wishItem.title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(vm.readOnly)
                        if !vm.readOnly || vm.wishItem.url?.isEmpty ?? false {
                            TextField("WISH_ITEM_TITLE_LINK_PLACEHOLER".localized, text: $vm.wishItem.url.safeValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(vm.readOnly)
                        }
                        Text("WISH_ITEM_TITLE_DESCRIPTION_PLACEHOLER".localized)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top)
                        TextView(text: $vm.wishItem.description.safeValue)
                            .font(.systemFont(ofSize: 17))
                            .setBorder(borderColor: .lightGray, borderWidth: 0.25, cornerRadius: 5)
                            .isEditable(!vm.readOnly)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 150, alignment: .leading)
                        LinkDataView(urlString: $vm.wishItem.url.safeValue)
                            .frame(height: 150)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                Spacer()
                if !vm.readOnly {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("EDIT_PROFILE_BUTTON_TITLE".localized)
                            .font(.title)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.lightText)
                            .cornerRadius(10)
                    })
                        .padding()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: setupTrailingNavBarItems())
            .onAppear {
                vm.loadWishItem()
            }
            .onDisappear {
                if !vm.readOnly {
                    vm.saveData()
                }
            }
        }
    }
    
    fileprivate func setupTrailingNavBarItems() -> some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("WISH_ITEM_CLOSE_BUTTON_TITLE".localized)
                    .foregroundColor(.selectedTabItem)
            })
        }
    }
}

struct WishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WishDetailsView(vm: WishDetailsViewModel(repository: DI.getWishListRepository(), readOnly: false))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            .previewDisplayName("iPhone SE (1st generation)")
    }
}
