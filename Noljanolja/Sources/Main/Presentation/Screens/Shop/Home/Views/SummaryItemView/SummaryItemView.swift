//
//  SummaryItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/11/2023.
//

import SwiftUI

struct SummaryItemView: View {
    var title: String
    var titleColorName: Color
    var imageName: String
    var value: String

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(titleColorName)
            HStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(titleColorName)
                    .frame(width: 28, height: 28)
                Text(value)
                    .dynamicFont(.systemFont(ofSize: 22))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 18)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(8)
    }
}
