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
        DataDetectorTextView(
            text: .constant(contentItemModel.message ?? ""),
            dataAction: {
                print("OOKOKOK", $0)
            }
        )
        .font(.system(size: 14, weight: .regular))
        .dataDetectorTypes(.link)
        .isEditable(false)
        .isScrollEnabled(false)
        .foregroundColor(
            contentItemModel.isSenderMessage
                ? ColorAssets.neutralLight.swiftUIColor
                : ColorAssets.neutralDarkGrey.swiftUIColor
        )
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            contentItemModel.isSenderMessage
                ? ColorAssets.neutralDarkGrey.swiftUIColor
                : ColorAssets.primaryLight.swiftUIColor
        )
    }
}

// MARK: - TextMessageContentView_Previews

struct TextMessageContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            TextMessageContentView(
                contentItemModel: TextMessageContentModel(
                    isSenderMessage: true,
                    message: "hello, www.google.com"
                )
            )
        }
    }
}
