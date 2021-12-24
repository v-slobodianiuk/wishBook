//
//  GlobalSearchCell.swift
//  WishBook
//
//  Created by Vadym on 29.03.2021.
//

import SwiftUI

struct GlobalSearchCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    
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
                    .lineLimit(2)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.selectedTabItem)
                    .padding(.horizontal)
                Text("\(birthDate ?? "")")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.selectedTabItem)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(cellBgView)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    fileprivate var cellBgView: some View {
        if colorScheme == .dark  {
            BlurView(style: .systemThinMaterialDark)
        } else {
            Color.lightText
        }
    }
}

struct GlobalSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        LazyVStack {
            GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
            GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
            GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
            GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
            GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
        }
    }
}
