//
//  LoginViewModel.swift
//  WishBook
//
//  Created by Vadym on 17.03.2021.
//

import Foundation
import Combine
import Firebase
import GoogleSignIn


struct LoginModel {
    var email: String
    var password: String
}

protocol LoginViewModelProtocol: ObservableObject {
    var loginModel: LoginModel { get set }
    var loginModelPublished: Published<LoginModel> { get }
    var loginModelPublisher: Published<LoginModel>.Publisher { get }
    
    var showWarning: Bool { get set }
    var showWarningPublished: Published<Bool> { get }
    var showWarningPublisher: Published<Bool>.Publisher { get }
    
    var error: String? { get }
    
    func loginPressed()
}

final class LoginViewModel: LoginViewModelProtocol {
    @Published var loginModel = LoginModel(email: "", password: "")
    var loginModelPublished: Published<LoginModel> { _loginModel }
    var loginModelPublisher: Published<LoginModel>.Publisher { $loginModel }
    
    @Published var showWarning = false
    var showWarningPublished: Published<Bool> { _showWarning }
    var showWarningPublisher: Published<Bool>.Publisher { $showWarning }
    
    var error: String?
    var profileData = ProfileModel()
    
    let googleAuthService: GoogleAuthServiceProtocol
    @Published private var repository: ProfileRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(googleAuthService: GoogleAuthServiceProtocol, repository: ProfileRepositoryProtocol) {
        self.googleAuthService = googleAuthService
        self.repository = repository
        
        print("LoginViewModel inited")
        additionalLoginServices()
    }
    
    func loginPressed() {
        googleAuthService.createUser(email: loginModel.email, password: loginModel.password) { [self] (result) in
            switch result {
            case .success(let user):
                if user == .new {
                    repository.addUserDataIfNeeded()
                }
            case .failure(let error):
                print("Login VM: \(error.localizedDescription)")
                self.error = error.localizedDescription
                showWarning = true
            }
        }
    }
    
    private func additionalLoginServices() {
        googleAuthService.googleSignIn = { [self] in
            repository.addUserDataIfNeeded()
        }
    }
}
