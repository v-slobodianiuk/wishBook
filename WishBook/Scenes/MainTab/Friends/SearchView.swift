//
//  SearchView.swift
//  WishBook
//
//  Created by Vadym on 29.03.2021.
//

import SwiftUI

struct SearchView: UIViewRepresentable {

    let placeholder: String
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<SearchView>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchView>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> SearchView.Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(placeholder: "Placeholder Text", text: .constant(""))
    }
}
