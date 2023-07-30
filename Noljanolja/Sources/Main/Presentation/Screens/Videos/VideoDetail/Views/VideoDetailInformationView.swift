//
//  VideoDetailInformationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import SwiftUI

struct VideoDetailInformationView: View {
    var video: Video
    var commentCount: Int?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 24) {
            buildHeaderView()
            buildContentView()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }

    private func buildHeaderView() -> some View {
        VStack(spacing: 6) {
            Text(video.title ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            if let category = video.category?.title, !category.isEmpty {
                Text("#\(category)")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.blue)
            }

            if let channelTitle = video.channel?.title, !channelTitle.isEmpty {
                Text(channelTitle)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 10))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
        }
    }

    private func buildContentView() -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 8) {
                Text(L10n.videoDetailViews)
                    .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)

                Text(video.viewCount.formatted())
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(12)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
                radius: 2,
                x: 0,
                y: 2
            )

            VStack(spacing: 8) {
                Text(L10n.videoDetailComment)
                    .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)

                if let commentCount = commentCount?.formatted() {
                    Text(commentCount)
                        .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(12)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
                radius: 2,
                x: 0,
                y: 2
            )

            VStack(spacing: 8) {
                Text(L10n.videoDetailReward)
                    .dynamicFont(.systemFont(ofSize: 12, weight: .medium))
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)

                Text(L10n.videoDetailRewardPoint(video.totalPoints.formatted()))
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(.orange)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(12)
            .shadow(
                color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
                radius: 2,
                x: 0,
                y: 2
            )
        }
    }
}
