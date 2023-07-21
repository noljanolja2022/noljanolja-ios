//
//  HighlightVideoItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - HighlightVideoItemView

struct HighlightVideoItemView: View {
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
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .scaledToFill()
    }
}
