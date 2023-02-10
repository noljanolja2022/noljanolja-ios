//
//  PrimaryButton.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//

import SwiftUI

// MARK: - PrimaryButton

struct PrimaryButton: View {
    var title = ""
    var action: () -> Void = {}
    @Binding var isEnabled: Bool
    var enabledForegroundColor: Color = ColorAssets.white.swiftUIColor
    var disabledForegroundColor: Color = ColorAssets.forcegroundSecondary.swiftUIColor
    var enabledBackgroundColor: Color = ColorAssets.highlightPrimary.swiftUIColor
    var disabledBackgroundColor: Color = ColorAssets.gray.swiftUIColor

    var body: some View {
        Button(
            action: action,
            label: {
                Text(title)
                    .font(FontFamily.NotoSans.bold.swiftUIFont(size: 16))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        )
        .frame(height: 48)
        .padding(.vertical, 4)
        .disabled(!isEnabled)
        .foregroundColor(
            isEnabled ? enabledForegroundColor : disabledForegroundColor
        )
        .background(
            isEnabled ? enabledBackgroundColor : disabledBackgroundColor
        )
        .cornerRadius(8)
        .shadow(
            color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
        )
    }
}

// MARK: - PrimaryButton_Previews

struct PrimaryButton_Previews: PreviewProvider {
    @State private static var isEnabled = true
    static var previews: some View {
        PrimaryButton(title: "Test Primary Button", isEnabled: $isEnabled)
    }
}
