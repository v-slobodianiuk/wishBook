//
//  WishDetailsView.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import SwiftUI

struct WishDetailsView: View {
    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var title: String = ""
    @State var description: String = ""
    @State var url: String = ""
    let isEditable: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        TextField("WISH_ITEM_TITLE_PLACEHOLER".localized, text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(!isEditable)
                        if isEditable || url.isEmpty {
                            TextField("WISH_ITEM_TITLE_LINK_PLACEHOLER".localized, text: $url)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(!isEditable)
                        }
                        Text("WISH_ITEM_TITLE_DESCRIPTION_PLACEHOLER".localized)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top)
                        TextView(text: $description)
                            .font(.systemFont(ofSize: 17))
                            .setBorder(borderColor: .lightGray, borderWidth: 0.25, cornerRadius: 5)
                            .isEditable(isEditable)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 150, alignment: .leading)
                        LinkDataView(urlString: $url)
                            .frame(height: 150)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                Spacer()
                if isEditable {
                    Button(action: {
                        if !title.isEmpty {
                            store.dispatch(
                                action: .wishes(
                                    action: .updateWishListWithItem(
                                        title: title,
                                        description: description.isEmpty ? nil : description,
                                        url: url.isEmpty ? nil : url
                                    )
                                )
                            )
                        }
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
                guard let selectedItem = store.state.wishes.selectedItem else { return }
                let wish = store.state.wishes.wishList[selectedItem]
                title = wish.title
                url = wish.url ?? ""
                description = wish.description ?? ""
            }
            .onDisappear {
                store.dispatch(action: .wishes(action: .discardSelection))
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
        WishDetailsView(isEditable: true)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            .previewDisplayName("iPhone SE (1st generation)")
    }
}
