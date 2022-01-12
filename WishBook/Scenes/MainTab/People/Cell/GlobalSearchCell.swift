//
//  GlobalSearchCell.swift
//  WishBook
//
//  Created by Vadym on 29.03.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct GlobalSearchCell: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var image: String?
    var firstName: String?
    var lastName: String?
    var birthDate: String?
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: image ?? ""))
                .resizable()
                .placeholder {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(.label)
                }
                .indicator(.activity)
                .transition(.fade(duration: Globals.defaultAnimationDuration))
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.leading)
            VStack(alignment: .leading) {
                Text("\(firstName ?? "") \(lastName ?? "")")
                    .lineLimit(2)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.label)
                    .padding(.horizontal)
                Text("\(birthDate ?? "")")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.label)
                    .padding(.horizontal)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(colorScheme == .dark ? Color.darkGray : Color.light)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

struct GlobalSearchCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchTextFieldView(searchText: .constant("test"))
            ScrollView {
                LazyVStack {
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                    GlobalSearchCell(image: nil, firstName: "Test", lastName: "Name", birthDate: "Birthdate: 2 october")
                }
            }
        }
        //.preferredColorScheme(.dark)
    }
}
