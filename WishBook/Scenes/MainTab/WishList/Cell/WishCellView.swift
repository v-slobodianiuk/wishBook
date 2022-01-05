//
//  WishCellView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 05.01.2022.
//

import SwiftUI

struct WishCellView: View {
    
    let title: String
    let currentIndex: Int
    let lastIndexItem: Int
    let paginationInProgress: Bool
    let fullLoadingComplete: Bool
    
    var loadingAction: Closure?
    var prepareAction: Closure?
    
    var body: some View {
        ZStack {
            if currentIndex == lastIndexItem && paginationInProgress {
                ProgressView()
            } else {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture { loadingAction?() }
            }
        }
        .onAppear {
            guard currentIndex == lastIndexItem, !fullLoadingComplete else { return }
            withAnimation { prepareAction?() }
        }
    }
}

struct WishCellView_Previews: PreviewProvider {
    
    private static let fakeTitles: [String] = ["Baz", "Bar"]
    
    static var previews: some View {
        List {
            ForEach(fakeTitles.indices, id: \.self) { index in
                WishCellView(
                    title: fakeTitles[index],
                    currentIndex: index,
                    lastIndexItem: fakeTitles.count - 1,
                    paginationInProgress: false,
                    fullLoadingComplete: true
                )
            }
        }
    }
}
