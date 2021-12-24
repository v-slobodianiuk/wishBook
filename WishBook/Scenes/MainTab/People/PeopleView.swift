//
//  PeopleView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct PeopleView: View {
    
    @EnvironmentObject var store: AppStore
    @State private var searchText: String = ""
    @State private var navLinkIsActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchView(placeholder: "PEOPLE_SEARCH_PLACEHOLDER".localized, text: $searchText)
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        withAnimation {
                            store.dispatch(action: .people(action: .fetch(searchText: newValue)))
                        }
                    }
                emptyView
            }
            .navigationBarTitle("FRIENDS_NAV_TITLE".localized)
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    fileprivate var emptyView: some View {
        ZStack {
            if store.state.people.fetchInProgress {
                ProgressView()
            } else {
                resultListView
            }
        }
        .frame(maxHeight: .infinity)
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
                            birthDate: store.state.people.getBirthdate()
                        )
                            .onTapGesture {
                                store.dispatch(action: .people(action: .prepareProfileDataFor(index: i)))
                                navLinkIsActive.toggle()
                            }
                    }
                }
            }
        }
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//.fixFlickering()
//        .onTapGesture {
//            endEditing()
//        }

//extension ScrollView {
//    private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>
//
//    func fixFlickering() -> some View {
//        GeometryReader { geo in
//            ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
//                content.padding(geo.safeAreaInsets) as! PaddedContent
//            }
//            .edgesIgnoringSafeArea(.all)
//        }
//    }
//}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            screenFactory.makePeopleView()
        }
    }
}
