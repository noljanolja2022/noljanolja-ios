//
//  ReceiverMessageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/03/2023.
//

import Kingfisher
import SDWebImageSwiftUI
import SwiftUI

// MARK: - ReceiverMessageView

struct ReceiverMessageView: View {
    var model: NormalMessageModel
    var action: ((ChatItemActionType) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        HStack(alignment: .top, spacing: 4) {
            buildAvatarView()

            VStack(alignment: .leading, spacing: 4) {
                if model.positionType == .all || model.positionType == .first {
                    Text("John Henrry")
                        .font(.system(size: 11, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 16)
                        .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                }

                MessageContentView(
                    model: model.content,
                    action: action
                )
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .cornerRadius(12)
            }

            Spacer(minLength: 60)
        }
        .padding(.leading, 16)
        .padding(
            .top,
            { () -> CGFloat in
                switch model.positionType {
                case .all, .first: return 16
                case .middle, .last: return 4
                }
            }()
        )
    }

    @ViewBuilder
    private func buildAvatarView() -> some View {
        if model.positionType == .all || model.positionType == .first {
            WebImage(
                url: URL(string: model.avatar ?? ""),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 32 * 3, height: 32 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .scaledToFill()
            .frame(width: 32, height: 32)
            .background(ColorAssets.neutralGrey.swiftUIColor)
            .cornerRadius(12)
        } else {
            Spacer()
                .frame(width: 32, height: 32)
        }
    }
}
