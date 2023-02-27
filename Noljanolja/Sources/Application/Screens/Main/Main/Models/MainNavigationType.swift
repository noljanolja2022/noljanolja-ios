//
//  MainNavigationType.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//

import Foundation

enum MainNavigationType: String, Identifiable {
    case authPopup
    case auth

    var id: String { rawValue }
}
