//
//  VideoDetailCommentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import SDWebImageSwiftUI
import SwiftUI

// MARK: - VideoDetailCommentView

struct VideoDetailCommentView: View {
    var comment: VideoComment

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            buildHeaderView()
            buildContentView()
        }
    }

    private func buildHeaderView() -> some View {
        HStack(spacing: 16) {
            WebImage(
                url: URL(string: comment.commenter?.avatar ?? ""),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 24 * 3, height: 24 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .scaledToFill()
            .frame(width: 24, height: 24)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(12)

            VStack(spacing: 4) {
                Text(comment.createdAt?.string(withFormat: "HH:mm - yyyy/MM/dd") ?? "")
                    .dynamicFont(.systemFont(ofSize: 11, weight: .semibold))
                    .foregroundColor(ColorAssets.neutralGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(comment.commenter?.name ?? "")
                    .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private func buildContentView() -> some View {
        HStack(spacing: 16) {
            ZStack {
                Divider()
                    .frame(width: 1)
                    .frame(maxHeight: .infinity)
                    .overlay(Color.clear)
            }
            .frame(width: 24)

            VStack(spacing: 8) {
                Text(comment.comment ?? "")
                    .multilineTextAlignment(.leading)
                    .dynamicFont(.systemFont(ofSize: 12))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .background(ColorAssets.neutralLight.swiftUIColor)
                    .cornerRadius(8)

                Divider()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .overlay(ColorAssets.neutralGrey.swiftUIColor)
            }
            .padding(.bottom, 12)
        }
    }
}
