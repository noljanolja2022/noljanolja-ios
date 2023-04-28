//
//  Navigation+Extension.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 11/02/2023.
//

import Foundation
import SwiftUI
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

    func update(backgroundColor: UIColor, foregroundColor: UIColor) {
        navigationBar.standardAppearance.backgroundColor = backgroundColor
        navigationBar.scrollEdgeAppearance?.backgroundColor = backgroundColor
        navigationBar.compactAppearance?.backgroundColor = backgroundColor

        navigationBar.standardAppearance.backgroundColor = backgroundColor
        navigationBar.scrollEdgeAppearance?.backgroundColor = backgroundColor
        navigationBar.compactAppearance?.backgroundColor = backgroundColor

        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance?.backgroundColor = backgroundColor
        }
    }
}

// MARK: - NavigationConfigurationViewModifier

struct NavigationConfigurationViewModifier: ViewModifier {
    @State var backgroundColor: Color
    @State var foregroundColor: Color

    func body(content: Content) -> some View {
        content
            .introspectViewController { viewController in
                guard let backgroundColor = backgroundColor.toUIColor(),
                      let foregroundColor = foregroundColor.toUIColor() else {
                    return
                }
                viewController.navigationController?.update(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor
                )
            }
            .onAppear {
                backgroundColor = backgroundColor
                foregroundColor = backgroundColor
            }
    }
}

extension View {
    @discardableResult
    func configure(backgroundColor: Color, foregroundColor: Color) -> some View {
        modifier(
            NavigationConfigurationViewModifier(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor
            )
        )
    }
}
