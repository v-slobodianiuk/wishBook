//
//  PasswordPromptView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 06.01.2022.
//

import SwiftUI

struct PasswordPromptView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            BlurView(style: colorScheme == .dark ? .systemThinMaterialDark : .systemThinMaterialLight)
                .ignoresSafeArea()
            
            contentView
        }
        .transition(.asymmetric(insertion: .scale, removal: .opacity))
        .onTapGesture { isPresented.toggle() }
    }
    
    fileprivate var contentView: some View {
        VStack {
            Spacer()
            Text("PASSWORD_PROMPT_TITLE".localized)
                .font(Font.title2)
                .foregroundColor(.selectedTabItem)
                .padding(.horizontal)
            
            Text("PASSWORD_PROMPT_DESCRIPTION".localized)
                .font(Font.body)
                .foregroundColor(.selectedTabItem)
                .padding(.top)
                .padding(.horizontal)
            
            Spacer()
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(colorScheme == .dark ? Color.azureBlue : Color.azurePurple)
            }
            .padding()
        }

    }
}

struct PasswordPromptView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordPromptView(isPresented: .constant(true))
            //.preferredColorScheme(.dark)
    }
}
