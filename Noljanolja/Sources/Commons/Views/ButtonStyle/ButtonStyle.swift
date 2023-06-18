//
//  PrimaryButton.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import SwiftUI

// MARK: - CustomButtonStyle

protocol CustomButtonStyle: ButtonStyle {
    var isEnabled: Bool { get }
    var enabledForegroundColor: Color { get }
    var disabledForegroundColor: Color { get }
    var enabledBackgroundColor: Color { get }
    var disabledBackgroundColor: Color { get }
    var enabledBorderColor: Color { get }
    var disabledBorderColor: Color { get }
}

extension CustomButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
//        let backgroundColor: Color = {
//            let enabledBackgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
//            let backgroundColor = configuration.isPressed ? enabledForegroundColor.opacity(0.5) : enabledForegroundColor
//            return backgroundColor
//        }()
//
//        let foregroundColor: Color = {
//            let enabledForegroundColor = isEnabled ? enabledForegroundColor : disabledForegroundColor
//            let foregroundColor = configuration.isPressed ? enabledForegroundColor.opacity(0.5) : enabledForegroundColor
//            return foregroundColor
//        }()
//
//        let borderColor: Color = {
//            let enabledBorderColor = isEnabled ? enabledBorderColor : disabledBorderColor
//            let borderColor = configuration.isPressed ? enabledBorderColor.opacity(0.5) : enabledBorderColor
//            return borderColor
//        }()

        configuration.label
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                isEnabled ? enabledBackgroundColor : disabledBackgroundColor
            )
            .foregroundColor(
                isEnabled ? enabledForegroundColor : disabledForegroundColor
            )
            .cornerRadius(4)
            .overlayBorder(
                color: isEnabled ? enabledBorderColor : disabledBorderColor, lineWidth: 1
            )
            .opacity(configuration.isPressed ? 0.5 : 1)
            .disabled(!isEnabled)
    }
}

// MARK: - PrimaryButtonStyle

struct PrimaryButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color
    let disabledForegroundColor: Color
    let enabledBackgroundColor: Color
    let disabledBackgroundColor: Color
    let enabledBorderColor: Color
    let disabledBorderColor: Color

    init(isEnabled: Bool = true,
         enabledForegroundColor: Color = ColorAssets.neutralDarkGrey.swiftUIColor,
         disabledForegroundColor: Color = ColorAssets.neutralDeepGrey.swiftUIColor,
         enabledBackgroundColor: Color = ColorAssets.primaryGreen200.swiftUIColor,
         disabledBackgroundColor: Color = ColorAssets.neutralGrey.swiftUIColor,
         enabledBorderColor: Color = Color.clear,
         disabledBorderColor: Color = Color.clear) {
        self.isEnabled = isEnabled
        self.enabledForegroundColor = enabledForegroundColor
        self.disabledForegroundColor = disabledForegroundColor
        self.enabledBackgroundColor = enabledBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.enabledBorderColor = enabledBorderColor
        self.disabledBorderColor = disabledBorderColor
    }
}

// MARK: - SecondaryButtonStyle

struct SecondaryButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.neutralLight.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.neutralGrey.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.neutralDarkGrey.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.neutralLightGrey.swiftUIColor
    let enabledBorderColor = Color.clear
    let disabledBorderColor = Color.clear

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - ThridyButtonStyle

struct ThridyButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.neutralDarkGrey.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.neutralGrey.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.neutralLight.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.neutralGrey.swiftUIColor
    let enabledBorderColor: Color = ColorAssets.neutralDarkGrey.swiftUIColor
    let disabledBorderColor: Color = ColorAssets.neutralGrey.swiftUIColor

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - PlainButtonStyle

struct PlainButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.neutralLight.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.neutralGrey.swiftUIColor

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(
                isEnabled ? enabledForegroundColor : disabledForegroundColor
            )
            .opacity(configuration.isPressed ? 0.5 : 1)
            .disabled(!isEnabled)
    }
}

// MARK: - MyCouponButtonStyle

struct MyCouponButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color
    let disabledForegroundColor: Color
    let enabledBackgroundColor: Color
    let disabledBackgroundColor: Color
    let enabledBorderColor: Color
    let disabledBorderColor: Color

    init(isEnabled: Bool = true,
         enabledForegroundColor: Color = ColorAssets.neutralDarkGrey.swiftUIColor,
         disabledForegroundColor: Color = ColorAssets.neutralDeepGrey.swiftUIColor,
         enabledBackgroundColor: Color = ColorAssets.secondaryYellow300.swiftUIColor,
         disabledBackgroundColor: Color = ColorAssets.secondaryYellow50.swiftUIColor,
         enabledBorderColor: Color = Color.clear,
         disabledBorderColor: Color = Color.clear) {
        self.isEnabled = isEnabled
        self.enabledForegroundColor = enabledForegroundColor
        self.disabledForegroundColor = disabledForegroundColor
        self.enabledBackgroundColor = enabledBackgroundColor
        self.disabledBackgroundColor = disabledBackgroundColor
        self.enabledBorderColor = enabledBorderColor
        self.disabledBorderColor = disabledBorderColor
    }
}
