//
//  FriendsView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI

struct FriendsView<VM: FriendsViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    let array = ["Peter", "Paul", "Mary", "Anna-Lena", "George", "John", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara"]
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }, onCommit: {
                            print("onCommit")
                        }).foregroundColor(.primary)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                    
                    if showCancelButton  {
                        Button("Cancel") {
                            UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            ForEach(0..<vm.usersList.count) { index in
                GlobalSearchCell(image: vm.usersList[index].photoUrl, firstName: vm.usersList[index].firstName, lastName: vm.usersList[index].lastName, birthDate: vm.getBirthdate(index: index))
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
