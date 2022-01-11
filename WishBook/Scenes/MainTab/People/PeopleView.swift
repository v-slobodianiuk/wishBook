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
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText: String = ""
    @State private var navLinkIsActive: Bool = false
    @State private var filterSegment: PeopleFilter = .all
    
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
                Text("All").tag(PeopleFilter.all)
                Text("Subscribers").tag(PeopleFilter.subscribers)
                Text("Subscriptions").tag(PeopleFilter.subscriptions)
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
        .navigationBarTitle("FRIENDS_NAV_TITLE".localized)
    }
    
    @ViewBuilder
    fileprivate var emptyView: some View {
        ZStack {
            if store.state.people.fetchInProgress {
                ProgressView()
            } else {
                if store.state.people.peopleList.isEmpty {
                    Text("🔎")
                        .font(.system(size: 100))
//                    Image(systemName: "rectangle.badge.person.crop")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundColor(.gray)
//                        .frame(width: 250, height: 250, alignment: .center)
                } else {
                    resultListView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .resignKeyboardOnTapGesture()
    }
    
    @ViewBuilder
    fileprivate var resultListView: some View {
        ScrollView {
            LazyVStack {
                Spacer(minLength: 8)
                ForEach(store.state.people.peopleList.indices, id: \.self) { i in
                    NavigationLink(isActive: $navLinkIsActive) {
                        screenFactory.makeSearchedProfileView()
                    } label: {
                        GlobalSearchCell(
                            image: store.state.people.peopleList[i].photoUrl,
                            firstName: store.state.people.peopleList[i].firstName,
                            lastName: store.state.people.peopleList[i].lastName,
                            birthDate: store.state.people.getBirthdate(date: store.state.people.peopleList[i].birthdate)
                        )
                            .onTapGesture {
                                store.dispatch(action: .people(action: .prepareProfileDataFor(index: i)))
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
