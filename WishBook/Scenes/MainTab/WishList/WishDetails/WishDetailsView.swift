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
    @Environment(\.colorScheme) var colorScheme
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var url: String = ""
    
    // MARK: - body
    var body: some View {
        NavigationView {
            VStack {
                detailsView
                    .padding(.top)
                
                Spacer()
                
                if wishState != .readOnly {
                    Button("EDIT_PROFILE_BUTTON_TITLE".localized) {
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
                    }
                    .buttonStyle(ConfirmButtonStyle())
                    .opacity(title.isEmpty ? 0.5 : 1.0)
                    .disabled(title.isEmpty)
                    .padding()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: trailingNavBarItems)
            .onAppear {
                guard wishState != .new else {
                    store.dispatch(action: .wishes(action: .clearWishDetails))
                    return
                }
                
                let wish: WishListModel?
                if wishState == .editable {
                    wish = store.state.wishes.wishDetails
                } else {
                    wish = store.state.people.searchedProfileWishDetails
                }
                
                title = wish?.title ?? ""
                url = wish?.url ?? ""
                description = wish?.description ?? (wishState == .editable ? "" : "WISH_ITEM_TITLE_DESCRIPTION_PLACEHOLER".localized)
            }
        }
    }
    
    // MARK: - DetailsView
    fileprivate var detailsView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TextField("WISH_ITEM_TITLE_PLACEHOLER".localized, text: $title)
                    .font(Font.title.weight(.medium))
                    .disabled(wishState == .readOnly)
                
                if wishState != .readOnly {
                    Divider()
                        .padding(.bottom, title.isEmpty ? 0 : 16)
                    
                    if title.isEmpty {
                        WarningText(text: "WISH_ITEM_TITLE_ERROR".localized)
                    }
                    
                    TextField("WISH_ITEM_TITLE_LINK_PLACEHOLER".localized, text: $url)
                        .font(Font.subheadline)
                        .foregroundColor(.main)
                    
                    Divider()
                        .padding(.bottom)

                    Text("WISH_ITEM_DETAILS_TITLE".localized.uppercased())
                        .font(Font.footnote)
                        .foregroundColor(.label)
                    
                    TextView(text: $description)
                        .backgroundColor(colorScheme == .dark ? UIColor.black : UIColor.systemGray6)
                        .font(.systemFont(ofSize: 14))
                        .textColor(.label)
                        .frame(height: 250)
                        //.border(Color(UIColor.systemGray5), width: 1)
                } else {
                    Text(description)
                        .font(Font.callout)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
                
                LinkDataView(urlString: $url)
                    .frame(height: 150)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - trailingNavBarItems
    fileprivate var trailingNavBarItems: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("WISH_ITEM_CLOSE_BUTTON_TITLE".localized)
                    .foregroundColor(.label)
            })
        }
    }
}

struct WishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeWishDetailsView()
            .wishState(.editable)
            //.wishState(.readOnly)
            //.preferredColorScheme(.dark)
            //.previewDevice(PreviewDevice(rawValue: "iPhone SE (1st generation)"))
            //.previewDisplayName("iPhone SE (1st generation)")
    }
}
