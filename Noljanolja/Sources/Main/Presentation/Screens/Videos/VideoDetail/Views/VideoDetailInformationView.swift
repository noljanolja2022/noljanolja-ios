//
//  VideoDetailInformationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import SwiftUI

struct VideoDetailInformationView: View {
    @EnvironmentObject var themeManager: AppThemeManager

    var video: Video
    var isLiked: Bool
    var commentCount: Int?
    var didTapLikeButton: ((String) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            buildHeaderView()
            buildLikeView()
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

                Text(L10n.videoDetailRewardPoint(video.earnedPoints.formatted()))
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

    private func buildLikeView() -> some View {
        HStack(spacing: 18) {
            HStack {
                Image(isLiked ? ImageAssets.icLikeFilled.name : ImageAssets.icLike.name)
                    .resizable()
                    .frame(width: 22, height: 20)
                    .foregroundColor(isLiked ? themeManager.theme.primary200 : ColorAssets.neutralRawDeeperGrey.swiftUIColor)
                Text(video.likeCountString)
                    .dynamicFont(.systemFont(ofSize: 12, weight: .regular))
                    .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
            }
            .onPress {
                didTapLikeButton?(video.id)
            }
            Divider()
                .foregroundColor(ColorAssets.neutralRawLightGrey.swiftUIColor)
            Button {
                //
            } label: {
                Text("Liked Video")
                    .dynamicFont(.systemFont(ofSize: 12, weight: .regular))
                    .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 15)
        .frame(height: 34)
        .background(ColorAssets.neutralRawLightGrey.swiftUIColor)
        .cornerRadius(30)
    }
}
