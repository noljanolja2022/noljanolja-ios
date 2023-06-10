//
//  AddFriendsNavigations.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/06/2023.
//

import Foundation

// MARK: - AddFriendsNavigationType

enum AddFriendsNavigationType {
    case contactList
    case result([User])
}

// MARK: - AddFriendsScreenCoverType

enum AddFriendsScreenCoverType: Equatable {
    case selectCountry
}
