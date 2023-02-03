//
//  NoljanoljaApp.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import FirebaseCore
import SwiftUI

// MARK: - AppDelegate

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

// MARK: - NoljanoljaApp

@main
struct NoljanoljaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
