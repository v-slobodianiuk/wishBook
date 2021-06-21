//
//  FriendsViewModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import Combine

protocol FriendsViewModelProtocol: ObservableObject {
    var router: FriendsRouterProtocol { get }
    var usersList: [ProfileModel] { get }
    var usersListPublished: Published<[ProfileModel]> { get }
    var usersListPublisher: Published<[ProfileModel]>.Publisher { get }
    
    var searchText: String { get set }
    var searchTextPublished: Published<String> { get }
    var searchTextPublisher: Published<String>.Publisher { get }
    
    func getUsersData()
    func getBirthdate(date: Date?) -> String
}

final class FriendsViewModel: FriendsViewModelProtocol {
    let router: FriendsRouterProtocol
    @Published private var usersRepository: UsersRepositoryProtocol
    @Published var usersList = [ProfileModel]()
    var usersListPublished: Published<[ProfileModel]> { _usersList }
    var usersListPublisher: Published<[ProfileModel]>.Publisher { $usersList }
    
    @Published var searchText = ""
    var searchTextPublished: Published<String> { _searchText }
    var searchTextPublisher: Published<String>.Publisher { $searchText }
    
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
        setupSearch()
    }
    
    func getUsersData() {
        //usersRepository.loadData()
        usersRepository.usersPublisher
            .assign(to: \.usersList, on: self)
            .store(in: &cancellables)
    }
    
    private func setupSearch() {
        searchTextPublisher
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .filter { $0.count <= 3 }
            .map { $0.lowercased() }
            .sink { [self] (text) in
                if text.isEmpty {
                    usersRepository.loadData()
                } else {
                    usersRepository.searchData(text)
                }
                
            }
            .store(in: &cancellables)
    }
    
    func getBirthdate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formattedDate = dateFormatter.string(from: date)
        return  "\("PROFILE_BIRTHDATE".localized): \(formattedDate)"
    }
}
