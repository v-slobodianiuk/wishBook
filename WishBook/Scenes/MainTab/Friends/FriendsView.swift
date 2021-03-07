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
        Text("Friends View")
            .navigationBarTitle("Friends")
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView(vm: FriendsViewModel())
    }
}
