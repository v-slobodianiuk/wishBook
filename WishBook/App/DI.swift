//
//  DI.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation

struct DI {
    
    private init() {}
    
    fileprivate static var profilePepository: ProfileRepositoryProtocol {
        ProfileRepository()
    }
}

extension DI {
    // MARK: Profile Repository
    static func getProfilePepository() -> ProfileRepositoryProtocol {
        return profilePepository
    }
}
