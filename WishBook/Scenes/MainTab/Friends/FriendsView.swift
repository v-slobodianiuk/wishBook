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
            ForEach(vm.usersList.indices, id: \.self) { i in
                GlobalSearchCell(
                    image: vm.usersList[i].photoUrl,
                    firstName: vm.usersList[i].firstName,
                    lastName: vm.usersList[i].lastName,
                    birthDate: vm.getBirthdate(date: vm.usersList[i].birthdate)
                )
            }
       }
        .resignKeyboardOnDragGesture()
        .navigationBarTitle("FRIENDS_NAV_TITLE".localized)
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(vm: FriendsViewModel(router: FriendsRouter(), usersRepository: DI.getUsersRepository()))
    }
}
