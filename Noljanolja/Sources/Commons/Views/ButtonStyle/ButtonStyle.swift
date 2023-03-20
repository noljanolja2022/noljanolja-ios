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
            .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
            .background(
                isEnabled ? enabledBackgroundColor : disabledBackgroundColor
            )
            .foregroundColor(
                isEnabled ? enabledForegroundColor : disabledForegroundColor
            )
            .cornerRadius(5)
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
    let enabledForegroundColor: Color = ColorAssets.neutralDarkGrey.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.neutralDeepGrey.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.primaryYellowMain.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.neutralGrey.swiftUIColor
    let enabledBorderColor = Color.clear
    let disabledBorderColor = Color.clear

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - SecondaryButtonStyle

struct SecondaryButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.white.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.black.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.gray.swiftUIColor
    let enabledBorderColor = Color.clear
    let disabledBorderColor = Color.clear

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - ThridyButtonStyle

struct ThridyButtonStyle: CustomButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.black.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor
    let enabledBackgroundColor: Color = ColorAssets.white.swiftUIColor
    let disabledBackgroundColor: Color = ColorAssets.gray.swiftUIColor
    let enabledBorderColor: Color = ColorAssets.black.swiftUIColor
    let disabledBorderColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor

    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
}

// MARK: - PlainButtonStyle

struct PlainButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let enabledForegroundColor: Color = ColorAssets.white.swiftUIColor
    let disabledForegroundColor: Color = ColorAssets.gray.swiftUIColor

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
