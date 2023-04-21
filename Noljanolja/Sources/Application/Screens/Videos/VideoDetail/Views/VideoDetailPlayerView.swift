//
//  VideoDetailPlayerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct VideoDetailPlayerView: View {
    var video: Video

    var body: some View {
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
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(CGSize(width: 9, height: 5), contentMode: .fill)
    }
}
