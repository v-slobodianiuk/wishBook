//
//  Optional.swift
//  WishBook
//
//  Created by Vadym on 22.06.2021.
//

import Foundation

extension Optional where Wrapped == String {
    var _safeValue: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var safeValue: String {
        get {
            return _safeValue ?? ""
        }
        set {
            _safeValue = newValue.isEmpty ? nil : newValue
        }
    }
}
