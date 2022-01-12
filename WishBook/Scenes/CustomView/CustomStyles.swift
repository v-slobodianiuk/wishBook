//
//  CustomStyles.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 06.01.2022.
//

import SwiftUI

//MARK: - ConfirmButtonStyle
struct ConfirmButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(LinearGradient(colors: [.mainPurple, .mainBlue], startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.light)
            .cornerRadius(10)
    }
}
