//
//  UserPageViewModel.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

import Foundation
import Combine

protocol UserPageViewModelProtocol: ObservableObject {

    var wishList: [WishListModel] { get }
    var wishListPublished: Published<[WishListModel]> { get }
    var wishListPublisher: Published<[WishListModel]>.Publisher { get }
    
    var router: WishListRouterProtocol { get }
    func getData()
    func getFullName() -> String
    func getBirthdate() -> String
    func getProfileData() -> ProfileModel?
}

final class UserPageViewModel: UserPageViewModelProtocol {
    let router: WishListRouterProtocol
    private var userId: String? = nil
    
    @Published private var profileRepository: ProfileRepositoryProtocol
    @Published private var wishListRepository: WishListRepositoryProtocol
    
    @Published var profileData = ProfileModel()
    
    @Published var wishList = [WishListModel]()
    var wishListPublished: Published<[WishListModel]> { _wishList }
    var wishListPublisher: Published<[WishListModel]>.Publisher { $wishList }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //let region = Locale.current
        //print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    init(
        router: WishListRouterProtocol,
        userId: String?,
        profileRepository: ProfileRepositoryProtocol,
        wishListRepository: WishListRepositoryProtocol
    ) {
        self.router = router
        self.userId = userId
        self.profileRepository = profileRepository
        self.wishListRepository = wishListRepository
    }
    
    func getData() {
        guard let userId = self.userId else { return }
        
        profileRepository.loadDataByUserId(userId)
        wishListRepository.loadDataByUserId(userId)
        
        wishListRepository.wishListPublisher
            .assign(to: \.wishList, on: self)
            .store(in: &cancellables)
        
        profileRepository.profilePublisher
            .assign(to: \.profileData, on: self)
            .store(in: &cancellables)
    }
    
    func getFullName() -> String {
        guard let firstName = profileData.firstName, let lastName = profileData.lastName else { return "" }
        return "\(firstName) \(lastName)"
    }
    
    func getBirthdate() -> String {
        guard let birthdate = profileData.birthdate else { return "" }
        let date = dateFormatter.string(from: birthdate)
        //return  "\("PROFILE_BIRTHDATE".localized): \(date)"
        return  date
    }
    
    func getProfileData() -> ProfileModel? {
        return profileData
    }
}
