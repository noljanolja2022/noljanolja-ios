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
    var exchangeCount: Int { get set }
    var appTheme: AppTheme { get set }
}

// MARK: - UserDefaults.Keys

extension UserDefaults {
    enum Keys {
        static let isNotFirstLaunch = "is_not_first_launch"
        static let exchangeCount = "exchange_count"
        static let appTheme = "app_theme"
    }
}

// MARK: - UserDefaults + UserDefaultsType

extension UserDefaults: UserDefaultsType {
    var isFirstLaunch: Bool {
        get { !bool(forKey: Keys.isNotFirstLaunch) }
        set { set(!newValue, forKey: Keys.isNotFirstLaunch) }
    }

    var exchangeCount: Int {
        get { integer(forKey: Keys.exchangeCount) }
        set { set(newValue, forKey: Keys.exchangeCount) }
    }

    var appTheme: AppTheme {
        get { AppTheme(rawValue: integer(forKey: Keys.appTheme)) ?? .green }
        set { set(newValue.rawValue, forKey: Keys.appTheme) }
    }
}
