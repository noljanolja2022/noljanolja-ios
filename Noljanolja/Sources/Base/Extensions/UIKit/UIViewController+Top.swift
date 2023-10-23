//
//  UIViewController+Top.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Foundation
import UIKit

extension UIViewController {
    var topViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController
        }
        if let tabBarController = self as? UITabBarController {
            if let selectedTabBarController = tabBarController.selectedViewController {
                return selectedTabBarController.topViewController
            }
        }
        if let presentedViewController {
            return presentedViewController.topViewController
        }
        return self
    }
}
