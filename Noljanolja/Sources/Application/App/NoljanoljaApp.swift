//
//  NoljanoljaApp.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/02/2023.
//

import _SwiftUINavigationState
import CombineExt
import Introspect
import SwifterSwift
import SwiftUI
import SwiftUINavigation

// MARK: - NoljanoljaApp

@main
struct NoljanoljaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
