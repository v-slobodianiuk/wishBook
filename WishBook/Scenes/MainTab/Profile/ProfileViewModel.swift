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
    func getUserImage(completion: @escaping ((URL?) -> Void))
    func uploadUserImage(imageData: Data?, completion: @escaping (() -> Void))
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    @Published var profileData: ProfileModel?
    
    @Published private var repository: ProfileRepositoryProtocol
    let router: ProfileRouterProtocol
    private let storageService: FirebaseStorageServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //let region = Locale.current
        //print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    init(router: ProfileRouterProtocol, repository: ProfileRepositoryProtocol, storageService: FirebaseStorageServiceProtocol) {
        self.router = router
        self.repository = repository
        self.storageService = storageService
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
        //return  "\("PROFILE_BIRTHDATE".localized): \(date)"
        return  "\(date)"
    }
    
    func getProfileData() -> ProfileModel? {
        return profileData
    }
    
    func getUserImage(completion: @escaping ((URL?) -> Void)) {
        guard let userId = profileData?.id else { return }
        storageService.getImage(userId: userId) { url in
            completion(url)
        }
    }
    
    func uploadUserImage(imageData: Data?, completion: @escaping (() -> Void)) {
        guard let userId = profileData?.id else { return }
        storageService.upload(imageData: imageData, userId: userId) { result in
            switch result {
            case .success(let isOk):
                if isOk {
                    completion()
                }
            case .failure(_):
                break
            }
        }
    }
}
