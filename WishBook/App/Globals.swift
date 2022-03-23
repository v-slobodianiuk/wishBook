//
//  Globals.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 30.12.2021.
//

import Foundation

public typealias Closure = () -> Void

struct Globals {
    static let defaultAnimationDuration: Double = 0.24
    static let photoRootFolder: String = "Photos"

    static let googleServiceResource: String = {
        return (Bundle.main.infoDictionary?["GOOGLE_SERVICE_RESOURCE"] as? String) ?? "GoogleService-Info"
    }()

    static let usersCollectionName: String = {
        return (Bundle.main.infoDictionary?["USERS_DB"] as? String) ?? "TestUsers"
    }()

    static let wishesCollectionName: String = {
        return (Bundle.main.infoDictionary?["WISHES_DB"] as? String) ?? "TestWishes"
    }()

    static let storageRootFolder: String = {
        return (Bundle.main.infoDictionary?["ROOT_STORAGE"] as? String) ?? "Test"
    }()
}
