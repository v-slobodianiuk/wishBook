//
//  StatisticBlockView.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 14.10.2021.
//

import SwiftUI

struct StatisticBlockView: View {
    
    private let router: UserPageRouterProtocol
    private let count: (subscribers: Int?, subscriptions: Int?, wishes: Int?)
    
    init(router: UserPageRouterProtocol, count: (subscribers: Int?, subscriptions: Int?, wishes: Int?)) {
        self.router = router
        self.count = count
    }
    
    var body: some View {
        HStack() {
            router.showPeople(filter: .subscribers) {
                statisticView(count: count.subscribers, title: "PROFILE_SUBSCRIBERS_COUNT_TITLE".localized)
            }

            profileHorizontalDivider()
            
            router.showPeople(filter: .subscriptions) {
                statisticView(count: count.subscriptions, title: "PROFILE_SUBSCRIPTIONS_COUNT_TITLE".localized)
            }
            
            profileHorizontalDivider()
            
            statisticView(count: count.wishes, title: "PROFILE_WISHES_COUNT_TITLE".localized)
        }
    }
    
    fileprivate func statisticView(count: Int?, title: String) -> some View {
        VStack {
            Text("\(count ?? 0)")
                .fontWeight(.medium)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
    
    fileprivate func profileHorizontalDivider() -> some View {
        Divider()
            .frame(height: 25)
            .padding(.horizontal, 8)
    }
}

struct StatisticBlockView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticBlockView(router: UserPageRouter(), count: (0, 0, 0))
    }
}
