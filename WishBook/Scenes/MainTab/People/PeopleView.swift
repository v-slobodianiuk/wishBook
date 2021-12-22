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
    
    var body: some View {
        ScrollView {
            SearchView(placeholder: "PEOPLE_SEARCH_PLACEHOLDER".localized, text: $searchText)
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    print(newValue)
                    store.dispatch(action: .people(action: .fetch(searchText: newValue.lowercased())))
                }
            ForEach(store.state.people.peopleList.indices, id: \.self) { i in
                //vm.router.showProfile(profileUserId: store.state.people.peopleList[i].id) {
                    GlobalSearchCell(
                        image: store.state.people.peopleList[i].photoUrl,
                        firstName: store.state.people.peopleList[i].firstName,
                        lastName: store.state.people.peopleList[i].lastName,
                        birthDate: store.state.people.getBirthdate(date: store.state.people.peopleList[i].birthdate)
                    )
                //}
            }
        }
        //.fixFlickering()
        .onTapGesture {
            endEditing()
            
        }
        .onAppear {

        }
        .navigationBarTitle("FRIENDS_NAV_TITLE".localized)
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

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
        screenFactory.makePeopleView()
    }
}
