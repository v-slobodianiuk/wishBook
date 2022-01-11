//
//  AuthState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

struct AuthState {
    var fetchInProgress: Bool = false
    var isLoggedIn: Bool = UserStorage.isLoggedIn
    var login: String = ""
    var password: String = ""
    var errorMessage: String? = nil
    
    var successfullyPaswordChanged: Bool = false
    var successfullyPaswordReset: Bool = false
    
    func isValidEmail(_ email: String) -> Bool {
        return EmailValidate.isValid(email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return PasswordValidate.isValid(password)
    }
}

struct EmailValidate {
    static func isValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z.]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

struct PasswordValidate {
    static func isValid(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&.,<>/()*~:;'-]).{8,32}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
} 

extension String {
    func removeWrongCharacters(from forbiddenChars: CharacterSet = .whitespaces) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
}
