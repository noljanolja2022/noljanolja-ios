//
//  CommonVideoItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct CommonVideoItemView: View {
    var model: Video
    var action: (() -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                WebImage(
                    url: URL(string: model.thumbnail),
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(
                                width: geometry.size.width * 3,
                                height: geometry.size.height * 3
                            ),
                            scaleMode: .aspectFill
                        )
                    ]
                )
                .resizable()
                .indicator(.activity)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(9 / 5, contentMode: .fill)

            buildContentView()
        }
    }

    private func buildContentView() -> some View {
        HStack(alignment: .top, spacing: 8) {
            buildMainView()
            buildActionView()
        }
    }

    private func buildMainView() -> some View {
        VStack(spacing: 2) {
            Text(model.title ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            if let category = model.category?.title, !category.isEmpty {
                Text("#\(category)")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
            }

            let description = [
                model.channel?.title,
                "\(model.viewCount.relativeFormatted()) Views",
                model.publishedAt.relative()
            ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " • ")
            Text(description)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .dynamicFont(.systemFont(ofSize: 10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
        }
    }

    private func buildActionView() -> some View {
        Button(
            action: {
                action?()
            },
            label: {
                ImageAssets.icMore.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        )
    }
}
