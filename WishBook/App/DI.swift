//
//  DI.swift
//  WishBook
//
//  Created by Vadym on 08.03.2021.
//

import Foundation

struct DI {
    
    private init() {}
    
    fileprivate static var profileRepository: ProfileRepositoryProtocol {
        return ProfileRepository()
    }
    
    fileprivate static var wishListRepository: WishListRepositoryProtocol {
        return WishListRepository()
    }
}

extension DI {
    // MARK: Profile Repository
    static func getProfileRepository() -> ProfileRepositoryProtocol {
        return profileRepository
    }
    
    // MARK: Wish List Repository
    static func getWishListRepository() -> WishListRepositoryProtocol {
        return wishListRepository
    }
}
