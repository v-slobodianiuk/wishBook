//
//  UserPageViewModel.swift
//  WishBook
//
//  Created by Вадим on 12.05.2021.
//

//import Foundation
//import Combine
//
//protocol UserPageViewModelProtocol: ObservableObject {
//
//    var wishList: [WishListModel] { get }
//    var wishListPublished: Published<[WishListModel]> { get }
//    var wishListPublisher: Published<[WishListModel]>.Publisher { get }
//    
//    var router: UserPageRouterProtocol { get }
//    var selectedItem: Int { get set }
//    var isSubscribed: Bool { get set }
//    
//    func getData()
//    func getFullName() -> String
//    func getBirthdate() -> String
//    func getProfileData() -> ProfileModel?
//    func subscribeAction()
//}
//
//final class UserPageViewModel: UserPageViewModelProtocol {
//    let router: UserPageRouterProtocol
//    private var userId: String? = nil
//    
//    @Published private var profileRepository: ProfileRepositoryProtocol
//    @Published private var wishListRepository: WishListRepositoryProtocol
//    private let usersRepository: UsersRepositoryProtocol
//    
//    @Published var profileData = ProfileModel()
//    
//    @Published var wishList = [WishListModel]()
//    var wishListPublished: Published<[WishListModel]> { _wishList }
//    var wishListPublisher: Published<[WishListModel]>.Publisher { $wishList }
//    
//    var selectedItem: Int = 0
//    @Published var isSubscribed: Bool = false
//    private var cancellables = Set<AnyCancellable>()
//    
//    private let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        //let region = Locale.current
//        //print("locate: \(region)")
//        formatter.locale = Locale(identifier: "ru-UA")
//        formatter.dateFormat = "d MMMM"
//        return formatter
//    }()
//    
//    init(
//        router: UserPageRouterProtocol,
//        userId: String?,
//        profileRepository: ProfileRepositoryProtocol,
//        wishListRepository: WishListRepositoryProtocol,
//        usersRepository: UsersRepositoryProtocol
//    ) {
//        self.router = router
//        self.userId = userId
//        self.profileRepository = profileRepository
//        self.wishListRepository = wishListRepository
//        self.usersRepository = usersRepository
//    }
//    
//    func getData() {
//        guard let userId = self.userId else { return }
//        
//        profileRepository.loadData()
//        profileRepository.loadDataByUserId(userId)
//        wishListRepository.loadDataByUserId(userId)
//        
//        wishListRepository.wishListPublisher
//            .assign(to: \.wishList, on: self)
//            .store(in: &cancellables)
//        
//        profileRepository.profilePublisher
//            .sink { [weak self] profileData in
//                print("profileData: \(profileData)")
//                guard let self = self, let uid = self.profileRepository.user?.uid else { return }
//                if profileData.id != uid {
//                    self.profileData = profileData
//                }
//                //print("uid: \(uid)")
//                //print("self.userId \(self.userId)")
//                //print("profileData.id: \(profileData.id)")
//                //print("USERID: \(self.profileRepository.user?.uid)")
//                guard profileData.id == uid, let profileId = self.userId, let subscriptions = profileData.subscriptions else { return }
//                self.isSubscribed = subscriptions.contains(profileId)
//            }
//            .store(in: &cancellables)
//    }
//    
//    func getFullName() -> String {
//        guard let firstName = profileData.firstName, let lastName = profileData.lastName else { return "" }
//        return "\(firstName) \(lastName)"
//    }
//    
//    func getBirthdate() -> String {
//        guard let birthdate = profileData.birthdate else { return "" }
//        let date = dateFormatter.string(from: birthdate)
//        //return  "\("PROFILE_BIRTHDATE".localized): \(date)"
//        return  date
//    }
//    
//    func getProfileData() -> ProfileModel? {
//        return profileData
//    }
//    
//    func subscribeAction() {
//        if isSubscribed {
//            usersRepository.unsubscribeFrom(id: self.userId)
//        } else {
//            usersRepository.subscribeTo(id: self.userId)
//        }
//    }
//}
