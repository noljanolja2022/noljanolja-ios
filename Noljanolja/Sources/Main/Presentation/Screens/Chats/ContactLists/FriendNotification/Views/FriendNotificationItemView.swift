//
//  FriendNotificationItemView.swift
//  Noljanolja
//
//  Created by Duy Dinh on 15/01/2024.
//

import SDWebImageSwiftUI
import SwiftUI

struct FriendNotificationItemView: View {
    let model: FriendNotificationItemModel

    var body: some View {
        HStack(spacing: 8) {
            WebImage(
                url: URL(string: model.avatarUrl),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(14)

            VStack(spacing: 8) {
                Text(model.title)
                    .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                Text(model.dateTime)
                    .dynamicFont(.systemFont(ofSize: 8, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            Spacer()
            Button {
                //
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 24, height: 24)
            }
        }
        .padding(16)
    }
}
