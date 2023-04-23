//
//  ConversationItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/03/2023.
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ConversationItemView

struct ConversationItemView: View {
    var model: ConversationItemModel

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            WebImage(
                url: URL(string: model.image ?? ""),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .placeholder {
                Image(systemName: model.imagePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(ColorAssets.neutralLight.swiftUIColor)
                    .padding(4)
            }
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(14)

            VStack(alignment: .leading, spacing: 8) {
                Text(model.title ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 16, weight: .medium))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

                if let message = model.message, !message.isEmpty {
                    Text(message)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 14, weight: .regular))
                        .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack(alignment: .trailing, spacing: 2) {
                Text(model.date ?? "")
                    .lineLimit(1)
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                if !model.isSeen {
                    Text("")
                        .frame(width: 6, height: 6)
                        .background(Color(hexadecimal: "BA1B1B"))
                        .cornerRadius(3)
                }
            }
            .padding(.top, 12)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
}
