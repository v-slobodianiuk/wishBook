//
//  PeopleState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation

struct PeopleState {
    var peopleList = [ProfileModel] ()
    var fetchInProgress: Bool = false
    var paginationInProgress: Bool = false
    var paginationCompleted: Bool = false
    var paginationLimit: Int = 20
    var errorMessage: String? = nil
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //let region = Locale.current
        //print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    func getBirthdate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formattedDate = dateFormatter.string(from: date)
        return  "\("PROFILE_BIRTHDATE".localized): \(formattedDate)"
    }
    
    func getLastIndexItem() -> Int {
        peopleList.count - 1
    }
}
