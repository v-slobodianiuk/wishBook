//
//  UserPageView.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import SwiftUI


struct UserPageView<VM: UserPageViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    @State private var wishDetailsIsPresented: Bool = false
    
    var body: some View {
        VStack() {
            HStack() {
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
            StatisticBlockView(router: vm.router, count: (
                subscribers: vm.getProfileData()?.subscribers?.count,
                subscriptions: vm.getProfileData()?.subscriptions?.count,
                wishes: vm.getProfileData()?.wishes))
            HStack {
                Text("PROFILE_BIRTHDATE_EMOJI".localized)
                Text(vm.getBirthdate())
                    .padding(.leading, 5)
                Spacer()
                Button {
                    vm.subscribeAction()
                } label: {
                    Text(vm.isSubscribed ? "USER_PAGE_BUTTON_UNSUBSCRIBE".localized : "USER_PAGE_BUTTON_SUBSCRIBE".localized)
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.lightText)
                        .cornerRadius(8)
                }
            }
            .padding()
            Divider()
            if #available(iOS 15.0, *) {
                listView()
                    .headerProminence(.increased)
            } else {
                listView()
            }
            //Spacer()
        }
        .onAppear {
            print(#function)
            if #available(iOS 15.0, *) {
                UITableView.appearance().sectionHeaderTopPadding = .leastNormalMagnitude
            }
            
            vm.getData()
        }
        .onDisappear {
            print(#function)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    fileprivate func listView() -> some View {
        List {
            ForEach(vm.wishList.indices, id: \.self) { index in
                Text(vm.wishList[index].title)
                    .onTapGesture {
                        //itemIndex = index
                        vm.selectedItem = index
                        wishDetailsIsPresented.toggle()
                    }
            }
            .listStyle(.plain)
        }
        .sheet(isPresented: $wishDetailsIsPresented) {
            vm.router.showWishDetails(wishItem: vm.wishList[vm.selectedItem], readOnly: true)
        }
    }
    
    struct UserPageView_Previews: PreviewProvider {
        static var previews: some View {
            let vm = UserPageViewModel(
                router: UserPageRouter(), userId: nil,
                profileRepository: DI.getProfileRepository(),
                wishListRepository: DI.getWishListRepository(),
                usersRepository: DI.getUsersRepository()
            )
            UserPageView(vm: vm as! VM)
        }
    }
}
