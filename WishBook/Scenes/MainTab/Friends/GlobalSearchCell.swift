//
//  GlobalSearchCell.swift
//  WishBook
//
//  Created by Vadym on 29.03.2021.
//

import SwiftUI

struct GlobalSearchCell: View {
    
    var image: String?
    var firstName: String?
    var lastName: String?
    var birthDate: String?
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.selectedTabItem)
                .padding(.leading)
            VStack(alignment: .leading) {
                Text("\(firstName ?? "") \(lastName ?? "")")
                    .font(.system(size: 20, weight: .medium))
                    .padding(.horizontal)
                Text("\(birthDate ?? "")")
                    .font(.system(size: 14, weight: .light))
                    .padding(.horizontal)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
