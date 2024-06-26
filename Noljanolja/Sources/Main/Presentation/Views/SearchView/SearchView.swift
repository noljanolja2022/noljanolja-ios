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
                .dynamicFont(.systemFont(ofSize: 16))
                .frame(maxWidth: .infinity)
                .introspectTextField { textField in
                    textField.returnKeyType = .search
                    textField.clearButtonMode = .whileEditing
                    textField.isUserInteractionEnabled = isUserInteractionEnabled
                }
        }
        .padding(.horizontal, 8)
        .height(Constant.SearchBar.height)
    }
}

// MARK: - SearchView_Previews

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(placeholder: L10n.commonSearch, text: .constant(""))
    }
}
