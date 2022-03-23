//
//  ProfileState.swift
//  WishBook
//
//  Created by Vadym Slobodianiuk on 15.12.2021.
//

import Foundation

struct ProfileState {
    var profileData: ProfileModel?

    var fetchInProgress: Bool = false
    var haveFullName: Bool = true
    var havePhoto: Bool {
        return profileData?.photoUrl != nil
    }

    var errorMessage: String?

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // let region = Locale.current
        // print("locate: \(region)")
        formatter.locale = Locale(identifier: "ru-UA")
        formatter.dateFormat = "d MMMM"
        return formatter
    }()

    func getFullName() -> String {
        guard let firstName = profileData?.firstName, let lastName = profileData?.lastName else { return "" }
        return "\(firstName) \(lastName)"
    }

    func getBirthdate() -> String {
        guard let birthdate = profileData?.birthdate else { return "" }
        let date = dateFormatter.string(from: birthdate)
        return  "\(date)"
    }

    func getPhotoUrl() -> URL? {
        return URL(string: profileData?.photoUrl ?? "")
    }

    func isValidDate(date: Date) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year], from: Date(), to: date)
        return (dateComponents.year ?? 0) <= -4
    }
}
