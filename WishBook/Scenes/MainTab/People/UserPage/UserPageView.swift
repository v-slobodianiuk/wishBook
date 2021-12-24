//
//  UserPageView.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import SwiftUI


struct UserPageView: View {

    @EnvironmentObject var store: AppStore
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
                    Text(store.state.people.getFullName())
                        .font(.title)
                        .padding(.top)
                        .padding(.horizontal)
                    Text(store.state.people.searchedProfile?.description ?? "")
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                Spacer()
            }
            StatisticBlockView(count: (
                subscribers: store.state.people.searchedProfile?.subscribers?.count,
                subscriptions: store.state.people.searchedProfile?.subscriptions?.count,
                wishes: store.state.people.searchedProfile?.wishes))
            HStack {
                Text("PROFILE_BIRTHDATE_EMOJI".localized)
                Text(store.state.people.getBirthdate())
                    .padding(.leading, 5)
                Spacer()
                Button {
                    //TODO: - Subscription action
                } label: {
                    //Text(vm.isSubscribed ? "USER_PAGE_BUTTON_UNSUBSCRIBE".localized : "USER_PAGE_BUTTON_SUBSCRIBE".localized)
                    Text("USER_PAGE_BUTTON_SUBSCRIBE".localized)
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
        }
        .onAppear {
            print(#function)
            if #available(iOS 15.0, *) {
                UITableView.appearance().sectionHeaderTopPadding = .leastNormalMagnitude
            }
            store.dispatch(action: .people(action: .fetchWishes(limit: nil)))
        }
        .onDisappear {
            store.dispatch(action: .people(action: .clearSearchedProfileData))
        }
        .navigationBarTitle("", displayMode: .inline)
    }
    
    fileprivate func listView() -> some View {
        List {
            ForEach(store.state.people.searchedProfileWishes.indices, id: \.self) { index in
                ZStack {
                    if index == store.state.people.getWishesLastIndexItem() && store.state.people.paginationInProgress {
                        ProgressView()
                    } else {
                        Text(store.state.people.searchedProfileWishes[index].title)
                            .onTapGesture {
                                store.dispatch(action: .people(action: .prepareWishDetailsFor(index: index)))
                                wishDetailsIsPresented.toggle()
                            }
                    }
                }
                .onAppear {
                    if index == store.state.people.getWishesLastIndexItem() {
                        guard !store.state.people.wishesPaginationCompleted else { return }
                        withAnimation {
                            store.dispatch(action: .people(action: .fetchWishesMore))
                        }
                    }
                }
            }
            //.listStyle(.plain)
        }
        .sheet(isPresented: $wishDetailsIsPresented) {
            screenFactory.makeWishDetailsView(isEditable: false)
        }
    }
}

struct UserPageView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeSearchedProfileView()
    }
}
