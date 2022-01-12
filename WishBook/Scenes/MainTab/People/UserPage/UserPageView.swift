//
//  UserPageView.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserPageView: View {

    @EnvironmentObject var store: AppStore
    @Environment(\.presentationMode) var presentationMode
    @State private var wishDetailsIsPresented: Bool = false
    
    var isSubscribed: Bool {
        store.state.profile.profileData?.subscriptions?.contains(store.state.people.searchedProfile?.id ?? "") ?? false
    }
    
    var body: some View {
        VStack() {
            HStack() {
                WebImage(url: URL(string: store.state.people.searchedProfile?.photoUrl ?? ""))
                    .resizable()
                    .placeholder {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundColor(.label)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.25))
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
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
                    withAnimation {
                        store.dispatch(action: .people(action: isSubscribed ? .unsubscribe : .subscribe))
                    }
                } label: {
                    Text(isSubscribed ? "USER_PAGE_BUTTON_UNSUBSCRIBE".localized : "USER_PAGE_BUTTON_SUBSCRIBE".localized)
                        .font(.subheadline)
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(LinearGradient(colors: [.mainPurple, .mainBlue], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.light)
                        .cornerRadius(8)
                }
                .disabled(store.state.people.subscribeIsDisabled)
            }
            .padding([.top, .horizontal])
            
            emptyView
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if store.state.profile.profileData == nil {
                store.dispatch(action: .profile(action: .fetch))
            }
        }
    }
    
    private var emptyView: some View {
        ZStack {
            if store.state.people.wishesFetchInProgress {
                ProgressView()
            } else {
                listView
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var listView: some View {
        List {
            ForEach(store.state.people.searchedProfileWishes.indices, id: \.self) { index in
                WishCellView(
                    title: store.state.people.searchedProfileWishes[index].title,
                    currentIndex: index,
                    lastIndexItem: store.state.people.getWishesLastIndexItem(),
                    paginationInProgress: store.state.people.wishesPaginationInProgress,
                    fullLoadingComplete: store.state.people.wishesFullDataLoadingCompleted,
                    loadingAction: {
                        store.dispatch(action: .people(action: .prepareWishDetailsFor(index: index)))
                        wishDetailsIsPresented.toggle()
                    }, prepareAction: {
                        store.dispatch(action: .people(action: .fetchWishesMore))
                    }
                )
            }
        }
        .onAppear {
            store.dispatch(action: .people(action: .fetchWishes(limit: nil)))
        }
        .sheet(isPresented: $wishDetailsIsPresented) {
            screenFactory.makeWishDetailsView()
                .wishState(.readOnly)
        }
    }
}

struct UserPageView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeSearchedProfileView()
    }
}
