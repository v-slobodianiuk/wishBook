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
    @Environment(\.wishState) var wishState
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var url: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        TextField("WISH_ITEM_TITLE_PLACEHOLER".localized, text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disabled(wishState == .readOnly)
                        if wishState != .readOnly {
                            TextField("WISH_ITEM_TITLE_LINK_PLACEHOLER".localized, text: $url)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Text("WISH_ITEM_TITLE_DESCRIPTION_PLACEHOLER".localized)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top)
                        TextView(text: $description)
                            .font(.systemFont(ofSize: 17))
                            .setBorder(borderColor: .lightGray, borderWidth: 0.25, cornerRadius: 5)
                            .isEditable(wishState != .readOnly)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 150, alignment: .leading)
                        LinkDataView(urlString: $url)
                            .frame(height: 150)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                Spacer()
                if wishState != .readOnly {
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
                guard wishState != .new else { return }
                
                let wish: WishListModel?
                if wishState == .editable {
                    wish = store.state.wishes.wishDetails
                } else {
                    wish = store.state.people.searchedProfileWishDetails
                }
                
                title = wish?.title ?? ""
                url = wish?.url ?? ""
                description = wish?.description ?? ""
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
        screenFactory.makeWishDetailsView()
            //.previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            //.previewDisplayName("iPhone SE (1st generation)")
    }
}
