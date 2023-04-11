//
//  TextMessageItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/03/2023.
//

import SwiftUI

// MARK: - TextMessageContentView

struct TextMessageContentView: View {
    var contentItemModel: TextMessageContentModel

    var body: some View {
        Text(contentItemModel.message ?? "")
            .font(.system(size: 14, weight: .regular))
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                contentItemModel.isSenderMessage
                    ? ColorAssets.neutralDarkGrey.swiftUIColor
                    : ColorAssets.primaryYellow0.swiftUIColor
            )
            .foregroundColor(
                contentItemModel.isSenderMessage
                    ? ColorAssets.neutralLight.swiftUIColor
                    : ColorAssets.neutralDarkGrey.swiftUIColor
            )
    }
}
