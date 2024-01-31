//
//  UserDefaults.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//

import Foundation

// MARK: - UserDefaultsType

protocol UserDefaultsType: AnyObject {
    var isFirstLaunch: Bool { get set }
    var exchangeCount: Int { get set }
    var appTheme: AppTheme { get set }
    var currentUserId: String { get set }
    var chatSingleIdNoti: Int { get set }
}

// MARK: - UserDefaults.Keys

extension UserDefaults {
    enum Keys {
        static let isNotFirstLaunch = "is_not_first_launch"
        static let exchangeCount = "exchange_count"
        static let appTheme = "app_theme"
        static let isNotificaion = "is_notification"
        static let currentUserId = "current_user_id"
        static let chatSingleIdNoti = "chat_single_id_noti"
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

    var isNotification: Bool {
        get { !bool(forKey: Keys.isNotificaion) }
        set { set(!newValue, forKey: Keys.isNotificaion) }
    }

    var currentUserId: String {
        get { string(forKey: Keys.currentUserId) ?? "" }
        set { set(newValue, forKey: Keys.currentUserId) }
    }

    @objc var chatSingleIdNoti: Int {
        get { integer(forKey: Keys.chatSingleIdNoti) }
        set { set(newValue, forKey: Keys.chatSingleIdNoti) }
    }
}
