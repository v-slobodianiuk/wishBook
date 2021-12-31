//
//  ProfileView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct ProfileView: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showingImagePicker = false
    @State private var inputImageData: Data?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Group {
                if store.state.profile.fetchInProgress {
                    ProgressView()
                } else {
                    contentView
                }
            }
            .navigationBarTitle("PROFILE_NAV_TITLE".localized)
            .navigationBarItems(trailing: trailingNavBarItems)
        }
        .navigationViewStyle(.stack)
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(imageData: self.$inputImageData)
        }
        .onAppear {
            store.dispatch(action: .profile(action: .fetch))
        }
    }
    
    @ViewBuilder
    fileprivate var contentView: some View {
        if store.state.profile.haveFullName {
           profileBlock
        } else {
            emptyView
        }
    }
    
    @ViewBuilder
    fileprivate var trailingNavBarItems: some View {
        HStack {
            NavigationLink {
                screenFactory.makeEditProfileView()
            } label: {
                Text("PROFILE_EDIT_BUTTON_TITLE".localized)
            }

            Button(action: {
                store.dispatch(action: .auth(action: .signOut))
            }, label: {
                Text("PROFILE_SIGN_OUT_BUTTON_TITLE".localized)
            })
        }
    }
    
    @ViewBuilder
    fileprivate var emptyView: some View {
        NavigationLink {
            screenFactory.makeEditProfileView()
        } label: {
            VStack(alignment: .center) {
                Text("🙈")
                    .font(.system(size: 100))
                    .padding()
                Text("EMPTY_VIEW_TITLE".localized)
                    .padding()
            }
        }
    }
    
    @ViewBuilder
    fileprivate var profileBlock: some View {
        VStack(alignment: .center) {
            Button {
                showingImagePicker.toggle()
            } label: {
                if store.state.profile.havePhoto {
                    WebImage(url: store.state.profile.getPhotoUrl())
                        .resizable()
                        .indicator(.activity) // Activity Indicator
                            .transition(.fade(duration: 0.25)) // Fade Transition with duration
                        .scaledToFill()
                        .frame(width: 150, height: 150, alignment: .center)
                        .clipShape(Circle())
                        .padding(.top, 50)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                        .foregroundColor(.selectedTabItem)
                        .padding(.top, 50)
                }
                
            }
            Text(store.state.profile.getFullName())
                .font(.title)
                .padding(.top)
                .padding(.horizontal)
                .padding(.horizontal)
            if let description = store.state.profile.profileData?.description {
                Text(description)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            StatisticBlockView(count: (
                subscribers: store.state.profile.profileData?.subscribers?.count,
                subscriptions: store.state.profile.profileData?.subscriptions?.count,
                wishes: store.state.profile.profileData?.wishes))
            HStack {
                Text("PROFILE_BIRTHDATE_EMOJI".localized)
                Text(store.state.profile.getBirthdate())
                    .padding(.leading, 5)
            }
            .padding()
            Spacer()
        }
    }
    
    fileprivate func loadImage() {
        guard let inputImage = inputImageData else { return }
        store.dispatch(action: .profile(action: .uploadProfilePhoto(data: inputImage)))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        screenFactory.makeProfileView()
    }
}
