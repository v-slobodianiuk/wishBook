//
//  Environment+Extension.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 31.12.2021.
//

import SwiftUI

private struct SearchResultFilterKey: EnvironmentKey {
    static let defaultValue: PeopleFilter = .all
}

extension EnvironmentValues {
    var searchResultFilter: PeopleFilter {
        get { self[SearchResultFilterKey.self] }
        set { self[SearchResultFilterKey.self] = newValue }
    }
}

//MARK: - CurrentTabKey
private struct CurrentTabKey: EnvironmentKey {
    //static let defaultValue: TabItems = .wishListView
    static var defaultValue: Binding<TabItems> = .constant(.wishListView)
}

extension EnvironmentValues {
    var currentTab: Binding<TabItems> {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
}

//MARK: - View Extension
extension View {
    func searchResultFilter(_ searchResultFilter: PeopleFilter) -> some View {
        environment(\.searchResultFilter, searchResultFilter)
    }
}
