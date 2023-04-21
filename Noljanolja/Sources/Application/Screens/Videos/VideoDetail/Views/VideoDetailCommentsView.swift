//
//  VideoDetailCommentsView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/04/2023.
//

import SwiftUI

// MARK: - VideoDetailCommentsView

struct VideoDetailCommentsView: View {
    var comments: [VideoComment]

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            buildHeader()
            buildContentView()
        }
        .padding(.horizontal, 16)
    }

    private func buildHeader() -> some View {
        VStack(spacing: 8) {
            Text("Comments")
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            HStack(spacing: 12) {
                Text("Popular")
                    .font(.system(size: 12, weight: .medium))
                    .frame(height: 28)
                    .padding(.horizontal, 12)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    .background(ColorAssets.neutralGrey.swiftUIColor)
                    .cornerRadius(14)
                Text("Newest")
                    .font(.system(size: 12, weight: .medium))
                    .frame(height: 28)
                    .padding(.horizontal, 12)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                    .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    .cornerRadius(14)
                Spacer()
            }
        }
    }

    private func buildContentView() -> some View {
        LazyVStack(spacing: 4) {
            ForEach(comments.indices, id: \.self) { _ in
                VideoDetailCommentView()
            }
        }
    }
}

// MARK: - VideoDetailCommentsView_Previews

struct VideoDetailCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        VideoDetailCommentsView(comments: [])
    }
}
