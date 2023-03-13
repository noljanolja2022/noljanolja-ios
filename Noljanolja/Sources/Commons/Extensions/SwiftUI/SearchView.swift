//
//  SerachView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/03/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - SearchView

struct SearchView: View {
    var placeholder = ""
    @Binding var text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
            TextField(placeholder, text: $text)
                .keyboardType(.phonePad)
                .textFieldStyle(FullSizeTappableTextFieldStyle())
                .frame(height: 32)
                .font(.system(size: 17))
            if !text.isEmpty {
                Button(
                    action: { text = "" },
                    label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 36)
        .background(ColorAssets.neutralLightGrey.swiftUIColor)
        .cornerRadius(10)
    }
}

// MARK: - SearchView_Previews

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: .constant(""))
    }
}
