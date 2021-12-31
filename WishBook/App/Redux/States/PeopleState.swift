//
//  PeopleState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 22.12.2021.
//

import Foundation

struct PeopleState {
    var peopleList = [ProfileModel] ()
    var searchedProfile: ProfileModel?
    
    var fetchInProgress: Bool = false
    var paginationInProgress: Bool = false
   
    var paginationCompleted: Bool = false
    
    var paginationLimit: Int = 20
    var errorMessage: String? = nil
    
    var searchedProfileWishes: [WishListModel] = [WishListModel]()
    var searchedProfileWishDetails: WishListModel?
    
    var wishesFetchInProgress: Bool = false
    var wishesPaginationInProgress: Bool = false
    var wishesFullDataLoadingCompleted: Bool = false
    
    var subscribeIsDisabled: Bool = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()
    
    func getFullName() -> String {
        guard let firstName = searchedProfile?.firstName, let lastName = searchedProfile?.lastName else { return "" }
        return "\(firstName) \(lastName)"
    }
    
    func getBirthdate(date: Date?) -> String {
        guard let date = date else { return "" }
        let formattedDate = dateFormatter.string(from: date)
        return  "\("PROFILE_BIRTHDATE".localized): \(formattedDate)"
    }
    
    func getBirthdate() -> String {
        guard let birthdate = searchedProfile?.birthdate else { return "" }
        let formattedDate = dateFormatter.string(from: birthdate)
        return  "\("PROFILE_BIRTHDATE".localized): \(formattedDate)"
    }
    
    func getLastIndexItem() -> Int {
        peopleList.count - 1
    }
    
    func getWishesLastIndexItem() -> Int {
        searchedProfileWishes.count - 1
    }
}
