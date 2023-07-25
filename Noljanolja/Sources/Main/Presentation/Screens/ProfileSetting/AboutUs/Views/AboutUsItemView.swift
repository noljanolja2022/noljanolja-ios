//
//  AboutUsItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//

import SwiftUI

// MARK: - AboutUsItemView

struct AboutUsItemView: View {
    let title: String
    let description: String

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .dynamicFont(.systemFont(ofSize: 14))
        .multilineTextAlignment(.leading)
    }
}

// MARK: - AboutUsItemView_Previews

struct AboutUsItemView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsItemView(title: "Title", description: "Description")
    }
}
