//
//  TrendingVideoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - TrendingVideoView

struct TrendingVideoView: View {
    var videos: [Video]

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 16) {
            Text("Today features")
                .font(.system(size: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .padding(.horizontal, 16)

            buildContentView()
        }
    }

    private func buildContentView() -> some View {
        LazyVStack(spacing: 24) {
            ForEach(videos.indices, id: \.self) { index in
                TrendingVideoItemView(video: videos[index])
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

// MARK: - TrendingVideoView_Previews

struct TrendingVideoView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingVideoView(videos: [])
    }
}
