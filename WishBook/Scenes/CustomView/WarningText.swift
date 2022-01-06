//
//  WarningText.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 06.01.2022.
//

import SwiftUI

struct WarningText: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    
    var body: some View {
        Text(text)
            .font(Font.footnote)
            .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
    }
}
