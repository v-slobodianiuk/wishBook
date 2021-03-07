//
//  Defaults.swift
//  WishBook
//
//  Created by Vadym on 06.03.2021.
//

import Foundation

@propertyWrapper
struct Storage<Value> {
    
    let key: String
    let defaultValue: Value
    
    var wrappedValue: Value {
        get {
            UserDefaults.standard.value(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}

final class UserStorage {
    @Storage<Bool>(key: "isLoggedIn", defaultValue: false)
    static var isLoggedIn
}