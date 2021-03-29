//
//  FriendsViewModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import Combine

protocol FriendsViewModelProtocol: ObservableObject {
    // Wrapped value
    var usersList: [ProfileModel] { get }
    // (Published property wrapper)
    var usersListPublished: Published<[ProfileModel]> { get }
    // Publisher
    var usersListPublisher: Published<[ProfileModel]>.Publisher { get }
    
    func getUsersData()
    func getBirthdate(index: Int) -> String
}

final class FriendsViewModel: FriendsViewModelProtocol {
    let router: FriendsRouterProtocol
    @Published private var usersRepository: UsersRepositoryProtocol
    @Published var usersList = [ProfileModel]()
    var usersListPublished: Published<[ProfileModel]> { _usersList }
    var usersListPublisher: Published<[ProfileModel]>.Publisher { $usersList }
    private var cancellables = Set<AnyCancellable>()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //let region = Locale.current
        //print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    init(router: FriendsRouterProtocol, usersRepository: UsersRepositoryProtocol) {
        self.router = router
        self.usersRepository = usersRepository
        getUsersData()
    }
    
    func getUsersData() {
        usersRepository.loadData()
        usersRepository.usersPublisher
            .assign(to: \.usersList, on: self)
            .store(in: &cancellables)
    }
    
    func getBirthdate(index: Int) -> String {
        guard let birthdate = usersList[index].birthdate else { return "" }
        let date = dateFormatter.string(from: birthdate)
        return  "\("PROFILE_BIRTHDATE".localized): \(date)"
    }
}
