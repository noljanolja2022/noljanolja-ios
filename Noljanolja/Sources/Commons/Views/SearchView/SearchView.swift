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
    var isUserInteractionEnabled = true

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
            TextField(placeholder, text: $text)
                .textFieldStyle(TappableTextFieldStyle())
                .keyboardType(.default)
                .font(.system(size: 17))
                .frame(maxWidth: .infinity)
                .introspectTextField { textField in
                    textField.returnKeyType = .search
                    textField.clearButtonMode = .whileEditing
                    textField.isUserInteractionEnabled = isUserInteractionEnabled
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
        SearchView(placeholder: "Search", text: .constant(""))
    }
}
