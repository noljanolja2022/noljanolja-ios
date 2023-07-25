//
//  Font+Dynamic.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/07/2023.
//

import Foundation
import SwiftUI
import SwiftUIX

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

extension UIFont {
    func dynamicFont(contentSizeCategory: ContentSizeCategory,
                     minScale: CGFloat,
                     maxScale: CGFloat) -> UIFont {
        let positiveSizeCategory = ContentSizeCategory.allCases.filter { $0.scaleLevel >= 0 }
        let negativeSizeCategory = ContentSizeCategory.allCases.filter { $0.scaleLevel <= 0 }

        let positiveStep = (maxScale - 1) / Double(positiveSizeCategory.count)
        let negativeStep = (1 - minScale) / Double(negativeSizeCategory.count)

        let scaledstep = min(positiveStep, negativeStep)
        let scaledDelta = contentSizeCategory.scaleLevel * scaledstep
        let scaledSize = pointSize + scaledDelta * pointSize

        let dynamicUIFont = withSize(scaledSize)

        return dynamicUIFont
    }
}

// MARK: - DynamicFont

extension DynamicFont {
    static let minScale = 0.25
    static let maxScale = 1.25
}

// MARK: - DynamicFont

struct DynamicFont: ViewModifier {
    @Environment(\.sizeCategory) private var contentSizeCategory
    private let originalFont: UIFont

    init(_ font: UIFont) {
        self.originalFont = font
    }

    func body(content: Content) -> some View {
        let dynamicUIFont = originalFont.dynamicFont(
            contentSizeCategory: contentSizeCategory,
            minScale: DynamicFont.minScale,
            maxScale: DynamicFont.maxScale
        )
        let dynamicFont = Font(dynamicUIFont)

        return content.font(dynamicFont)
    }
}

extension View {
    func dynamicFont(_ font: UIFont) -> some View {
        modifier(DynamicFont(font))
    }
}
