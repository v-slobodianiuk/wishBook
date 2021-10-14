//
//  PeopleViewModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import Combine

protocol PeopleViewModelProtocol: ObservableObject {
    var router: PeopleRouterProtocol { get }
    var usersList: [ProfileModel] { get }
    var usersListPublished: Published<[ProfileModel]> { get }
    var usersListPublisher: Published<[ProfileModel]>.Publisher { get }
    
    var searchText: String { get set }
    var searchTextPublished: Published<String> { get }
    var searchTextPublisher: Published<String>.Publisher { get }
    
    func getUsersData()
    func setupSearch()
    func getBirthdate(date: Date?) -> String
}

final class PeopleViewModel: PeopleViewModelProtocol {
    let router: PeopleRouterProtocol
    @Published private var usersRepository: UsersRepositoryProtocol
    @Published var usersList = [ProfileModel]()
    var usersListPublished: Published<[ProfileModel]> { _usersList }
    var usersListPublisher: Published<[ProfileModel]>.Publisher { $usersList }
    
    @Published var searchText = ""
    var searchTextPublished: Published<String> { _searchText }
    var searchTextPublisher: Published<String>.Publisher { $searchText }
    
    private var cancellables = Set<AnyCancellable>()
    
    var filter: PeopleFilter?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //let region = Locale.current
        //print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    init(router: PeopleRouterProtocol, usersRepository: UsersRepositoryProtocol) {
        self.router = router
        self.usersRepository = usersRepository
    }
    
    func getUsersData() {
        usersRepository.usersPublisher
            .assign(to: \.usersList, on: self)
            .store(in: &cancellables)
    }
    
    func setupSearch() {
        searchTextPublisher
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .filter { $0.count <= 3 }
            .map { $0.lowercased() }
            .sink { [self] (text) in
                if text.isEmpty {
                    if let filterCase = filter {
                        usersRepository.loadPeopleByFilter(filterCase)
                    } else {
                        usersRepository.loadData()
                    }
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
