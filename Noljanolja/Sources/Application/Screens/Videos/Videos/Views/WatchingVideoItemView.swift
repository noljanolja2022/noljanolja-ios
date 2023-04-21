//
//  WatchingVideoItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct WatchingVideoItemView: View {
    var video: Video

    var body: some View {
        VStack(spacing: 8) {
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
                .scaledToFill()
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .clipped()
            }
            .frame(height: 80)

            Text(video.title ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .font(.system(size: 8, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .frame(width: 152)
    }
}
