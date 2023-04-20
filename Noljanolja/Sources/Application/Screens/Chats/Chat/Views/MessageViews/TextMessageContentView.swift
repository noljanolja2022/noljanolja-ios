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
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        ZStack {
            Text(contentItemModel.message ?? "")
                .font(.system(size: 14, weight: .regular))
                .background(.clear)
                .foregroundColor(.clear)
            DataDetectorTextView(
                text: .constant(contentItemModel.message ?? ""),
                dataAction: {
                    action?(.openURL($0))
                }
            )
            .font(.system(size: 14, weight: .regular))
            .dataDetectorTypes(.link)
            .isEditable(false)
            .isScrollEnabled(false)
            .foregroundColor(
                ColorAssets.primaryDark.swiftUIColor
            )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            contentItemModel.isSenderMessage
                ? Color(hexadecimal: "B8EB42")
                : ColorAssets.neutralLightGrey.swiftUIColor
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
