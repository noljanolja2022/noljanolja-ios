//
//  EnviromentKey.swift
//  Noljanolja
//
//  Created by duydinhv on 05/01/2024.
//

import SwiftUI
import UIKit

// MARK: - ViewControllerHolder

struct ViewControllerHolder {
    weak var value: UIViewController?
}

// MARK: - ViewControllerKey

struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder {
        ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
    }
}

extension EnvironmentValues {
    var viewController: UIViewController? {
        get { self[ViewControllerKey.self].value }
        set { self[ViewControllerKey.self].value = newValue }
    }
}
