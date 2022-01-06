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
            .background(LinearGradient(colors: [.azurePurple, .azureBlue], startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.lightText)
            .cornerRadius(10)
    }
}
