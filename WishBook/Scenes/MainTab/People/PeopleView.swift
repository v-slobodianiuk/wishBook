//
//  PeopleView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI
import Combine

struct PeopleView: View {

    @EnvironmentObject var store: AppStore
    @State private var searchText: String = ""
    @State private var navLinkIsActive: Bool = false
    @State private var filterSegment: PeopleFilter = .all

    // MARK: - body
    var body: some View {
        VStack {
            SearchTextFieldView(searchText: $searchText)
                .onChange(of: searchText) { newValue in
                    if newValue.isEmpty {
                        store.dispatch(action: .people(action: .clearSearch))
                        return
                    }

                    withAnimation {
                        filterSegment = .all
                        store.dispatch(action: .people(action: .fetch(searchText: newValue)))
                    }
                }

            Picker("", selection: $filterSegment) {
                Text("ALL_PEOPLE_TITLE".localized).tag(PeopleFilter.all)
                Text("SUBSCRIBERS_TITLE".localized).tag(PeopleFilter.subscribers)
                Text("SUBSCRIPTIONS_TITLE".localized).tag(PeopleFilter.subscriptions)
            }
            .onChange(of: filterSegment) { newValue in
                guard let profileData = store.state.profile.profileData else { return }
                switch newValue {
                case .all:
                    store.dispatch(action: .people(action: .clearSearch))
                case .subscribers:
                    store.dispatch(action: .people(action: .subscribersList(data: profileData)))
                    searchText.removeAll()
                    endEditing()
                case .subscriptions:
                    store.dispatch(action: .people(action: .subscriptionsList(data: profileData)))
                    searchText.removeAll()
                    endEditing()
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .pickerStyle(SegmentedPickerStyle())

            emptyView
        }
        .navigationBarTitle("PEOPLE_NAV_TITLE".localized)
    }

    // MARK: - Empty View
    fileprivate var emptyView: some View {
        ZStack {
            if store.state.people.fetchInProgress {
                ProgressView()
            } else {
                if store.state.people.peopleList.isEmpty {
                    Image(systemName: "magnifyingglass.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.main)
                        .opacity(0.2)
                } else {
                    resultListView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .resignKeyboardOnTapGesture()
    }

    // MARK: - List View
    fileprivate var resultListView: some View {
        ScrollView {
            LazyVStack {
                Spacer(minLength: 10)
                ForEach(store.state.people.peopleList.indices, id: \.self) { index in
                    NavigationLink(isActive: $navLinkIsActive) {
                        screenFactory.makeSearchedProfileView()
                    } label: {
                        GlobalSearchCell(
                            image: store.state.people.peopleList[index].photoUrl,
                            firstName: store.state.people.peopleList[index].firstName,
                            lastName: store.state.people.peopleList[index].lastName,
                            birthDate: store.state.people.getBirthdate(date: store.state.people.peopleList[index].birthdate)
                        )
                            .onTapGesture {
                                store.dispatch(action: .people(action: .prepareProfileDataFor(index: index)))
                                navLinkIsActive.toggle()
                            }
                    }
                }
            }
        }
        .resignKeyboardOnDragGesture()
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
            screenFactory.makePeopleView()
            .preferredColorScheme(.light)
    }
}
