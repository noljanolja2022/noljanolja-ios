//
//  Filea.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 12/02/2023.
//

import Foundation
import SwiftUI

// MARK: - AuthTextFieldStyle

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 24)
            .font(FontFamily.NotoSans.medium.swiftUIFont(size: 16))
    }
}

// MARK: - AuthTextFieldStyle

extension View {
    func setAuthTextFieldStyle() -> some View {
        frame(height: 50)
            .background(ColorAssets.gray.swiftUIColor)
            .cornerRadius(8)
            .shadow(color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1)
    }

    func overlayBorder(color: Color, lineWidth: CGFloat = 1) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: 14).stroke(color, lineWidth: lineWidth)
        )
    }
}
