//
//  ProfileViewModel.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation
import Combine
import Firebase

protocol ProfileViewModelProtocol: ObservableObject {
    var router: ProfileRouterProtocol { get }
    func emptyViewIsHidden() -> Bool
    func signOut()
    func getData()
    func getFullName() -> String
    func getBirthdate() -> String
    func getProfileData() -> ProfileModel?
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    @Published var profileData: ProfileModel?
    
    @Published private var repository: ProfileRepositoryProtocol
    let router: ProfileRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //let region = Locale.current
        //print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    init(router: ProfileRouterProtocol, repository: ProfileRepositoryProtocol) {
        self.router = router
        self.repository = repository
        getData()
    }
    
    func emptyViewIsHidden() -> Bool {
        return profileData?.firstName != nil
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign Out error: \(error.localizedDescription)")
        }
    }
    
    func getData() {
        repository.loadData()
        
        repository.profilePublisher.sink { [self] (profileData: ProfileModel) in
//            print("-----------------------------")
//            print(profileData)
//            print("-----------------------------")
            self.profileData = profileData
        }
        .store(in: &cancellables)
    }
    
    func getFullName() -> String {
        guard let firstName = profileData?.firstName, let lastName = profileData?.lastName else { return "" }
        return "\(firstName) \(lastName)"
    }
    
    func getBirthdate() -> String {
        guard let birthdate = profileData?.birthdate else { return "" }
        let date = dateFormatter.string(from: birthdate)
        return  "\("PROFILE_BIRTHDATE".localized): \(date)"
    }
    
    func getProfileData() -> ProfileModel? {
        return profileData
    }
}
