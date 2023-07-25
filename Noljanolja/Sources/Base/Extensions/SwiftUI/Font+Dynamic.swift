//
//  Font+Dynamic.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/07/2023.
//

import Foundation
import SwiftUI

extension ContentSizeCategory {
    var scaleLevel: Double {
        switch self {
        case .extraSmall: return -3
        case .small: return -2
        case .medium: return -1
        case .large: return 0
        case .extraLarge: return 1
        case .extraExtraLarge: return 2
        case .extraExtraExtraLarge: return 3
        case .accessibilityMedium: return 4
        case .accessibilityLarge: return 5
        case .accessibilityExtraLarge: return 6
        case .accessibilityExtraExtraLarge: return 7
        case .accessibilityExtraExtraExtraLarge: return 8
        @unknown default: return 0
        }
    }
}

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) private var sizeCategory
    private let originalfont: UIFont

    init(_ font: UIFont) {
        self.originalfont = font
    }

    func body(content: Content) -> some View {
        let minRatio: CGFloat = 0.5
        let maxRatio: CGFloat = 2.0

        let positiveSizeCategory = ContentSizeCategory.allCases.filter { $0.scaleLevel >= 0 }
        let negativeSizeCategory = ContentSizeCategory.allCases.filter { $0.scaleLevel <= 0 }
        let positiveStep = (maxRatio - 1) / Double(positiveSizeCategory.count)
        let negativeStep = (1 - minRatio) / Double(negativeSizeCategory.count)
        let scaledstep = min(positiveStep, negativeStep)
        let scaledDelta = sizeCategory.scaleLevel * scaledstep
        let scaledSize = originalfont.pointSize + scaledDelta * originalfont.pointSize
        let scaledFont = Font(originalfont.withSize(scaledSize) as CTFont)
        return content.font(scaledFont)
    }
}

extension View {
    func scaledFont(_ font: UIFont) -> some View {
        return self.modifier(ScaledFont(font))
    }
}
