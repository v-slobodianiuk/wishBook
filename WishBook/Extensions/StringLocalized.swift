//
//  StringLocalized.swift
//  WishBook
//
//  Created by Vadym on 07.03.2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
