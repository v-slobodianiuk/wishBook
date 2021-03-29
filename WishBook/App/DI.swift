//
//  DI.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation

struct DI {
    
    private init() {}
    
    fileprivate static var googleAuthService: GoogleAuthServiceProtocol {
        return GoogleAuthService()
    }
    
    fileprivate static var profileRepository: ProfileRepositoryProtocol {
        return ProfileRepository()
    }
    
    fileprivate static var wishListRepository: WishListRepositoryProtocol {
        return WishListRepository()
    }
    
    fileprivate static var usersRepository: UsersRepositoryProtocol {
        return UsersRepository()
    }
}

extension DI {
    
    // MARK: Google Auth Service
    static func getGoogleAuthService() -> GoogleAuthServiceProtocol {
        return googleAuthService
    }
    
    // MARK: Profile Repository
    static func getProfileRepository() -> ProfileRepositoryProtocol {
        return profileRepository
    }
    
    // MARK: Wish List Repository
    static func getWishListRepository() -> WishListRepositoryProtocol {
        return wishListRepository
    }
    
    // MARK: Users Repository
    static func getUsersRepository() -> UsersRepositoryProtocol {
        return usersRepository
    }
}
