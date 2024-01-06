//
//  UIViewController+Top.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/10/2023.
//

import Foundation
import SwiftUI
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

extension UIViewController {
    func present(style: UIModalPresentationStyle = .overFullScreen, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder builder: () -> some View) {
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        toPresent.modalTransitionStyle = transitionStyle
        toPresent.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, toPresent)
        )
        present(toPresent, animated: true, completion: nil)
    }
}
