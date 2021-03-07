//
//  AppDelegateFactory.swift
//  WishBook
//
//  Created by Vadym on 06.03.2021.
//

import Foundation

enum AppDelegateFactory {
    static func makeDefault() -> AppDelegateType {
        return CompositeAppDelegate(appDelegates: [GoogleAppDelegate()])
    }
}
