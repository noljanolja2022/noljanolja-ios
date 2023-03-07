//
//  UserDefaults.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//

import Foundation

// MARK: - UserDefaultsType

protocol UserDefaultsType {
    var isFirstLaunch: Bool { get set }
}

// MARK: - UserDefaults.Keys

extension UserDefaults {
    enum Keys {
        static let isFirstLaunch = "is_first_launch"
    }
}

// MARK: - UserDefaults + UserDefaultsType

extension UserDefaults: UserDefaultsType {
    var isFirstLaunch: Bool {
        get { bool(forKey: Keys.isFirstLaunch) }
        set { set(newValue, forKey: Keys.isFirstLaunch) }
    }
}
