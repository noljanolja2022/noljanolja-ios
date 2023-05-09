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

// MARK: - SingleChatSeenView

struct SingleChatSeenView: View {
    let isSeen: Bool

    var body: some View {
        if isSeen {
            ImageAssets.icChatSeen.swiftUIImage
                .frame(width: 16, height: 16)
        }
    }
}

// MARK: - GroupChatSeenView

struct GroupChatSeenView: View {
    let count: Int

    var body: some View {
        if count > 0 {
            Text(String(count))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)
        }
    }
}
