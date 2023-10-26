//
//  UIApplication+Extension.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//

import Foundation
import SwiftUI
import UIKit

extension UIApplication {
    var rootKeyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

extension UIWindow {
    var topViewController: UIViewController? {
        rootViewController?.topViewController
    }
}
