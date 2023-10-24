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
        if #available(iOS 15, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication
                .shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        }
    }
    
    var keyWindowPresentedController: UIViewController? {
        var viewController = keyWindow?.rootViewController
        
        if let presentedController = viewController as? UITabBarController {
            viewController = presentedController.selectedViewController
        }
        
        while let presentedController = viewController?.presentedViewController {
            if let presentedController = presentedController as? UITabBarController {
                viewController = presentedController.selectedViewController
            } else {
                viewController = presentedController
            }
        }
        return viewController
    }
}

extension UIWindow {
    var topViewController: UIViewController? {
        rootViewController?.topViewController
    }
}
