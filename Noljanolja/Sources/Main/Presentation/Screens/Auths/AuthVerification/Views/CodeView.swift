//
//  CodeView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import Introspect
import SwiftUI
import SwiftUIX
import UIKit

// MARK: - CodeView

struct CodeView: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    var action: (() -> Void)?

    private let maxLength = 6

    var body: some View {
        ZStack {
            CocoaTextField(
                text: $text.max(maxLength),
                label: { Text("") }
            )
            .keyboardType(.numberPad)
            .focused($isFocused)
            .frame(width: 0, height: 0)

            HStack(spacing: 12) {
                ForEach(0..<maxLength, id: \.self) { index in
                    buildDigitView(index)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                text = ""
                isFocused = true
            }
        }
        .frame(height: 48)
        .onChange(of: text) { text in
            if text.count == maxLength {
                isFocused = false
                action?()
            }
        }
    }

    @ViewBuilder
    private func buildDigitView(_ index: Int) -> some View {
        let digit = text[safe: index].flatMap { String($0) } ?? ""
        let color: Color = {
            guard text.count < maxLength else {
                return ColorAssets.primaryGreen200.swiftUIColor
            }
            if index < text.count {
                return ColorAssets.neutralDarkGrey.swiftUIColor
            } else {
                return ColorAssets.neutralGrey.swiftUIColor
            }
        }()
        VStack(spacing: 0) {
            Text(digit)
                .font(.system(size: 28, weight: .medium))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(color)
            Spacer()
                .frame(height: 2)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(1)
        }
    }
}

// MARK: - CodeView_Previews

struct CodeView_Previews: PreviewProvider {
    @State private static var text = "123456"

    static var previews: some View {
        CodeView(text: $text, isFocused: .constant(true))
    }
}
