//
//  UserPageView.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import SwiftUI

struct UserPageView<VM: UserPageViewModelProtocol>: View {

    @ObservedObject var vm: VM

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.selectedTabItem)
                    .padding(.leading)
                VStack(alignment: .leading) {
                    Text(vm.getFullName())
                        .font(.title)
                        .padding(.top)
                        .padding(.horizontal)
                    Text(vm.getProfileData()?.description ?? "")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                Spacer()
            }
            HStack {
                VStack {
                    Text("\(vm.getProfileData()?.subscribers?.count ?? 0)")
                        .fontWeight(.medium)
                    Text("PROFILE_SUBSCRIBERS_COUNT_TITLE".localized)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Divider()
                    .frame(height: 25)
                    .padding(.horizontal, 8)
                VStack {
                    Text("\(vm.getProfileData()?.subscriptions?.count ?? 0)")
                        .fontWeight(.medium)
                    Text("PROFILE_SUBSCRIPTIONS_COUNT_TITLE".localized)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Divider()
                    .frame(height: 25)
                    .padding(.horizontal, 8)
                VStack {
                    Text("\(vm.getProfileData()?.wishes ?? 0)")
                        .fontWeight(.medium)
                    Text("PROFILE_WISHES_COUNT_TITLE".localized)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            HStack {
                Text("🎂")
                Text(vm.getBirthdate())
                    .padding(.leading, 5)
            }
            .padding()
            Divider()
            List {
                ForEach(vm.wishList) { item in
                    Text(item.title)
                }
            }
            Spacer()
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            let vm = UserPageViewModel(
                router: WishListRouter(),
                profileRepository: DI.getProfileRepository(),
                wishListRepository: DI.getWishListRepository()
            )
            // swiftlint:disable force_cast
            UserPageView(vm: vm as! VM)
        }
    }
}
