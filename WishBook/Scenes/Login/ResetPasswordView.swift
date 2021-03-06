//
//  ResetPasswordView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 11.01.2022.
//

import SwiftUI

struct ResetPasswordView: View {
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
            
            Image(systemName: "checkmark.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .foregroundColor(.main)
                .opacity(0.2)
            
            Text("SUCCESS_TITLE".localized)
                .font(Font.largeTitle)
                .foregroundColor(.label)
                .padding()
            
            Button {
                guard let mailURL = URL(string: "message://"), UIApplication.shared.canOpenURL(mailURL) else { return }
                UIApplication.shared.open(mailURL)
            } label: {
                HStack {
                    Image(systemName: "tray")
                        .foregroundColor(.main)
                    Text("RESET_PASSWORD_TEXT".localized.uppercased())
                        .foregroundColor(.main)
                }
                .padding(.all, 8)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.main, lineWidth: 1)
                    )
            }
            
            Spacer()
            
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.main)
            }
            .padding()
        }

    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
