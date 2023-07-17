//
//  Navigation+Extension.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/02/2023.
//

import Foundation
import UIKit

extension UINavigationController {
    @discardableResult
    func configure(backgroundColor: UIColor, foregroundColor: UIColor) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .clear

        appearance.titleTextAttributes = [.foregroundColor: foregroundColor]

        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: foregroundColor]
        appearance.buttonAppearance = buttonAppearance
        appearance.doneButtonAppearance = buttonAppearance
        appearance.backButtonAppearance = buttonAppearance

        let backImage = ImageAssets.icBack.image.withTintColor(foregroundColor, renderingMode: .alwaysOriginal)
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance

        navigationBar.barStyle = .black

        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = appearance
        }

        return appearance
    }
}
