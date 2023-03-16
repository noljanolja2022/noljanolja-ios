//
//  CodeView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 25/02/2023.
//

import SwiftUI

// MARK: - CodeView

struct CodeView: View {
    private let maxLength = 6

    @Binding private var text: String
    private let action: (() -> Void)?

    init(text: Binding<String>, action: (() -> Void)? = nil) {
        self._text = text
        self.action = action
    }

    var body: some View {
        ZStack {
            TextField("", text: $text.max(maxLength))
                .textFieldStyle(TappableTextFieldStyle())
                .keyboardType(.numberPad)
            GeometryReader { geometry in
                HStack(spacing: 12) {
                    let size = min(
                        (geometry.size.width - CGFloat(maxLength - 1) * 12) / CGFloat(maxLength),
                        geometry.size.height
                    )
                    ForEach(0...5, id: \.self) { index in
                        let digit = text[safe: index].flatMap { String($0) } ?? ""
                        Text(digit)
                            .font(FontFamily.NotoSans.bold.swiftUIFont(size: 36))
                            .frame(width: size, height: size)
                            .background(ColorAssets.gray.swiftUIColor)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
        .frame(height: 64)
        .onChange(of: text) { text in
            if text.count == maxLength {
                action?()
            }
        }
    }
}

// MARK: - CodeView_Previews

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView(text: .constant(""))
    }
}
