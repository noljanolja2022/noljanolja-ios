//
//  WatchingVideoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SwiftUI

// MARK: - WatchingVideoView

struct WatchingVideoView: View {
    var videos: [Video]
    var seeAllAction: (() -> Void)?
    var selectAction: ((Video) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        LazyVStack(spacing: 7) {
            buildHeaderView()
            buildContentView()
        }
    }

    private func buildHeaderView() -> some View {
        HStack(spacing: 4) {
            Text(L10n.videoListWatchingToGetPoint)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(
                action: {
                    seeAllAction?()
                },
                label: {
                    ImageAssets.icArrowRight.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            )
        }
        .padding(.horizontal, 16)
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
    }

    private func buildContentView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(videos, id: \.id) { video in
                    WatchingVideoItemView(video: video)
                        .onTapGesture { selectAction?(video) }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - WatchingVideoView_Previews

struct WatchingVideoView_Previews: PreviewProvider {
    static var previews: some View {
        WatchingVideoView(videos: [])
    }
}
