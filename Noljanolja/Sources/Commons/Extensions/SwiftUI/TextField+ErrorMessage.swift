//
//  CustomTextField.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/02/2023.
//

import SwiftUI
import UIKit

// MARK: - ErrorViewModifier

struct ErrorViewModifier: ViewModifier {
    @Binding var message: String?

    func body(content: Content) -> some View {
        VStack(spacing: 6) {
            content

            if let message {
                Text(message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(ColorAssets.red.swiftUIColor)
                    .font(.system(size: 14))
            }
        }
    }
}

extension View {
    func errorMessage(_ message: Binding<String?>) -> some View {
        modifier(ErrorViewModifier(message: message))
    }
}
