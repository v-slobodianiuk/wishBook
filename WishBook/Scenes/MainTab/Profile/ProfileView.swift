//
//  ProfileView.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct ProfileView<VM: ProfileViewModelProtocol>: View {
    
    @ObservedObject var vm: VM
    @State private var showingImagePicker = false
    //self.showingImagePicker = true
    @State private var inputImage: UIImage?
    @State private var image: WebImage?
    private let firebaseStorage = FirebaseStorageService()
    
    var body: some View {
        ZStack {
            if vm.emptyViewIsHidden() {
                profileBlock()
            } else {
                emptyView()
            }
        }
        .navigationBarTitle("PROFILE_NAV_TITLE".localized)
        .navigationBarItems(trailing: setupTrailingNavBarItems())
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
        .onAppear(perform: {
            vm.getUserImage { url in
                image = WebImage(url: url)
            }
        })
    }
    
    fileprivate func setupTrailingNavBarItems() -> some View {
        HStack {
            vm.router.goEditProfile(profileData: vm.getProfileData()) {
                Text("PROFILE_EDIT_BUTTON_TITLE".localized)
            }
            Button(action: {
                vm.signOut()
            }, label: {
                Text("PROFILE_SIGN_OUT_BUTTON_TITLE".localized)
            })
        }
    }
    
    fileprivate func emptyView() -> some View {
        vm.router.goEditProfile(profileData: vm.getProfileData()) {
            VStack(alignment: .center) {
                Text("🙈")
                    .font(.system(size: 100))
                    .padding()
                Text("EMPTY_VIEW_TITLE".localized)
                    .padding()
            }
        }
    }
    
    fileprivate func profileBlock() -> some View {
        VStack(alignment: .center) {
            Button {
                showingImagePicker.toggle()
            } label: {
                
                if image != nil {
                    image?
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding(.top, 50)
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.selectedTabItem)
                        .padding(.top, 50)
                }
                
            }
            Text(vm.getFullName())
                .font(.title)
                .padding(.top)
                .padding(.horizontal)
                .padding(.horizontal)
            if let description = vm.getProfileData()?.description {
                Text(description)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            statisticBlockView()
            HStack {
                Text("PROFILE_BIRTHDATE_EMOJI".localized)
                Text(vm.getBirthdate())
                    .padding(.leading, 5)
            }
            .padding()
            Spacer()
        }
    }
    
    fileprivate func statisticBlockView() -> some View {
        HStack() {
            vm.router.showPeople(filter: .subscribers) {
                statisticView(count: vm.getProfileData()?.subscribers?.count, title: "PROFILE_SUBSCRIBERS_COUNT_TITLE".localized)
            }

            profileHorizontalDivider()
            
            vm.router.showPeople(filter: .subscriptions) {
                statisticView(count: vm.getProfileData()?.subscriptions?.count, title: "PROFILE_SUBSCRIPTIONS_COUNT_TITLE".localized)
            }
            
            profileHorizontalDivider()
            
            statisticView(count: vm.getProfileData()?.wishes, title: "PROFILE_WISHES_COUNT_TITLE".localized)
        }
    }
    
    fileprivate func statisticView(count: Int?, title: String) -> some View {
        VStack {
            Text("\(count ?? 0)")
                .fontWeight(.medium)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
    
    fileprivate func profileHorizontalDivider() -> some View {
        Divider()
            .frame(height: 25)
            .padding(.horizontal, 8)
    }
    
    fileprivate func loadImage() {
        guard let inputImage = inputImage else { return }
        let resizedImage = inputImage.downsample(to: CGSize(width: 1000, height: 1000), scale: nil)
        print("Image: \(inputImage.scale) | \(inputImage.size)")
        // Convert the image into JPEG and compress the quality to reduce its size
        let data: Data? = resizedImage.jpegData(compressionQuality: 0.75)
        
        vm.uploadUserImage(imageData: data) {
            vm.getUserImage { url in
                image = WebImage(url: url)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(vm: ProfileViewModel(
            router: ProfileRouter(),
            repository: DI.getProfileRepository(),
            storageService: DI.getFirebaseStorage()
        ))
    }
}
