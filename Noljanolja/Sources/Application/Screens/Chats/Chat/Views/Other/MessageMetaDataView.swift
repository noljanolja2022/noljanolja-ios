//
//  MessageMetaDataView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/05/2023.
//

import SwifterSwift
import SwiftUI

// MARK: - MessageCreatedDateTimeView

struct MessageCreatedDateTimeView: View {
    var model: Date

    var body: some View {
        Text(model.string(withFormat: "HH:mm"))
            .font(.system(size: 12))
    }
}

// MARK: - MessageSeenByView

struct MessageSeenByView: View {
    let seenByType: SeenByType?

    var body: some View {
        if let seenByType {
            switch seenByType {
            case let .single(isSeen):
                if isSeen {
                    ImageAssets.icChatSeen.swiftUIImage
                        .frame(width: 16, height: 16)
                } else {
                    EmptyView()
                }
            case let .group(count):
                if count > 0 {
                    Text(String(count))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)
                } else {
                    EmptyView()
                }
            case .unknown:
                EmptyView()
            }
        } else {
            EmptyView()
        }
    }
}
