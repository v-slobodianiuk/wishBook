//
//  SearchTextFieldView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 30.12.2021.
//

import SwiftUI

struct SearchTextFieldView: View {

    @Binding var searchText: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                TextField("PEOPLE_SEARCH_PLACEHOLDER".localized, text: $searchText)
                    .foregroundColor(.gray)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onChange(of: searchText) { newValue in
                        withAnimation {
                            self.isEditing = !newValue.isEmpty
                        }
                    }

                if isEditing {
                    Button {
                        self.searchText = ""
                        self.isEditing = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
            }
            .padding(.vertical, 8)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}
