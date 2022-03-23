//
//  ProfileImageView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 12.01.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileImageView: View {

    let stringUrl: String?

    var body: some View {
        WebImage(url: URL(string: stringUrl ?? ""))
            .resizable()
            .placeholder {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundColor(.label)
            }
            .indicator(.activity)
            .transition(.fade(duration: Globals.defaultAnimationDuration))
            .scaledToFill()
            .clipShape(Circle())
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(stringUrl: "")
    }
}
