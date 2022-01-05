//
//  Environment+Extension.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 31.12.2021.
//

import SwiftUI

enum WishState {
    case new
    case readOnly
    case editable
}

//MARK: - Wish State
private struct WishStateKey: EnvironmentKey {
    static let defaultValue: WishState = .readOnly
}

extension EnvironmentValues {
    var wishState: WishState {
        get { self[WishStateKey.self] }
        set { self[WishStateKey.self] = newValue }
    }
}

//MARK: - View Extension
extension View {
    func wishState(_ state: WishState) -> some View {
        environment(\.wishState, state)
    }
}
