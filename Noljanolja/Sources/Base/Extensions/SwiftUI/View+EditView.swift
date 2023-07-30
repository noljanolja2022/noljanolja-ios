//
//  View+EditView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 14/03/2023.
//

import Foundation
import SwiftUI

// MARK: - EditViewModifier

struct EditViewModifier: ViewModifier {
    private let title: String
    private let isHighlight: Bool
    private let color: Color?
    private let highlightColor: Color?

    init(title: String,
         isHighlight: Bool = false,
         color: Color? = nil,
         highlightColor: Color? = nil) {
        self.title = title
        self.isHighlight = isHighlight
        self.color = color
        self.highlightColor = highlightColor
    }

    func body(content: Content) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .dynamicFont(.systemFont(ofSize: 12))
                .foregroundColor(isHighlight ? highlightColor : color)
                .frame(maxWidth: .infinity, alignment: .leading)

            content

            Divider()
                .frame(height: 2)
                .foregroundColor(isHighlight ? highlightColor : color)
        }
    }
}

extension View {
    func editView(title: String, isHighlight: Bool, color: Color? = nil, highlightColor: Color? = nil) -> some View {
        modifier(
            EditViewModifier(
                title: title,
                isHighlight: isHighlight,
                color: color,
                highlightColor: highlightColor
            )
        )
    }
}
