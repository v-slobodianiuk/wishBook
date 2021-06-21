//
//  FriendsView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct FriendsView<VM: FriendsViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    
    var body: some View {
        ScrollView {
            SearchView(placeholder: "Last name", text: $vm.searchText)
                .padding(.horizontal)
            ForEach(vm.usersList.indices, id: \.self) { i in
                vm.router.showProfile(userId: vm.usersList[i].id) {
                    GlobalSearchCell(
                        image: vm.usersList[i].photoUrl,
                        firstName: vm.usersList[i].firstName,
                        lastName: vm.usersList[i].lastName,
                        birthDate: vm.getBirthdate(date: vm.usersList[i].birthdate)
                    )
                }
            }
        }
        .fixFlickering()
        .onTapGesture {
            endEditing()
            
        }
        .navigationBarTitle("FRIENDS_NAV_TITLE".localized)
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension ScrollView {
    private typealias PaddedContent = ModifiedContent<Content, _PaddingLayout>
    
    func fixFlickering() -> some View {
        GeometryReader { geo in
            ScrollView<PaddedContent>(axes, showsIndicators: showsIndicators) {
                content.padding(geo.safeAreaInsets) as! PaddedContent
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(vm: FriendsViewModel(router: FriendsRouter(), usersRepository: DI.getUsersRepository()))
    }
}
