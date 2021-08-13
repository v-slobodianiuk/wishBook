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
    func signInPressed()
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
    }
    
    func loginPressed() {
        googleAuthService.createUser(email: loginModel.email, password: loginModel.password) { [weak self] (result) in
            switch result {
            case .success(let user):
                if user == .new {
                    self?.repository.addUserDataIfNeeded()
                }
            case .failure(let error):
                print("Login VM: \(error.localizedDescription)")
                self?.error = error.localizedDescription
                self?.showWarning = true
            }
        }
    }
    
    func signInPressed() {
        googleAuthService.signInUser { [weak self] in
            self?.repository.addUserDataIfNeeded()
        }
    }
}
