//
//  VideoMessageContentView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 28/07/2023.
//

import SDWebImageSwiftUI
import SwiftUI

struct VideoMessageContentView: View {
    let model: VideoMessageContentModel
    let action: ((VideoMessageContentModel.ActionType) -> Void)?

    @State private var geometryProxy: GeometryProxy?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .background(
                GeometryReader { geometry in
                    MessageContentBackgroundView(
                        model: model.background
                    )
                    .onAppear {
                        geometryProxy = geometry
                    }
                }
            )
            .onTapGesture {
                action?(.openVideoDetail(model.video))
            }
            .onLongPressGesture {
                action?(.openMessageActionDetail(geometryProxy))
            }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                WebImage(
                    url: URL(string: model.thumbnail),
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(9 / 5, contentMode: .fill)

            Text(model.title ?? "")
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .dynamicFont(.systemFont(ofSize: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }
        .padding(.bottom, 12)
        .padding(.top, 8)
        .padding(.horizontal, 8)
    }
}
