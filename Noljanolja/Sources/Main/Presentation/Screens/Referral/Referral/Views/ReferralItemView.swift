//
//  ReferralItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 02/08/2023.
//

import SwiftUI

// MARK: - ReferralItemViewModel

struct ReferralItemViewModel: Equatable {
    let imageName: String
    let title: String
    let description: String
}

// MARK: - ReferralItemView

struct ReferralItemView: View {
    let model: ReferralItemViewModel

    var body: some View {
        VStack(spacing: 8) {
            Image(model.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .cornerRadius(50)

            Text(model.title)
                .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)

            Text(model.description)
                .dynamicFont(.systemFont(ofSize: 12))
                .multilineTextAlignment(.center)
                .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
            
            Spacer()
        }
    }
}
