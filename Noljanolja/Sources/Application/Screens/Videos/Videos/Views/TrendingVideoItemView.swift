//
//  TrendingVideoItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct TrendingVideoItemView: View {
    var video: Video

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                WebImage(
                    url: URL(string: video.thumbnail),
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(
                                width: geometry.size.width * 3,
                                height: geometry.size.height * 3
                            ),
                            scaleMode: .fill
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
            .aspectRatio(CGSize(width: 9, height: 5), contentMode: .fill)

            buildContentView()
        }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 2) {
            Text(video.title ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            if let category = video.category?.title, !category.isEmpty {
                Text("#\(category)")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
            }

            let description = [
                video.channel?.title,
                (video.viewCount?.relativeFormatted()).flatMap { "\($0) Views" },
                video.publishedAt.relative()
            ]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " • ")
            Text(description)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.system(size: 10))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
        }
    }
}
