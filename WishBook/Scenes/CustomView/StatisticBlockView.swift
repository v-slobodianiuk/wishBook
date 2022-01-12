//
//  StatisticBlockView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 14.10.2021.
//

import SwiftUI

struct StatisticBlockView: View {
    
    let count: (subscribers: Int?, subscriptions: Int?, wishes: Int?)
    
    var body: some View {
        HStack {
            statisticView(count: count.subscribers, title: "PROFILE_SUBSCRIBERS_COUNT_TITLE".localized)
            
            profileHorizontalDivider
            
            statisticView(count: count.subscriptions, title: "PROFILE_SUBSCRIPTIONS_COUNT_TITLE".localized)
            
            profileHorizontalDivider
            
            statisticView(count: count.wishes, title: "PROFILE_WISHES_COUNT_TITLE".localized)
        }
    }
    
    fileprivate var profileHorizontalDivider: some View {
        Divider()
            .frame(height: 25)
            .padding(.horizontal, 8)
    }
    
    fileprivate func statisticView(count: Int?, title: String) -> some View {
        VStack {
            Text("\(count ?? 0)")
                .fontWeight(.medium)
                .foregroundColor(.main)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

struct StatisticBlockView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticBlockView(count: (0, 0, 0))
    }
}
