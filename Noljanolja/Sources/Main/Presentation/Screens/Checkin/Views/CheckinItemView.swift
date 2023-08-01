//
//  CheckinItemView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 01/08/2023.
//

import SwiftUI

// MARK: - CheckinItemStatus

enum CheckinItemStatus {
    case checked
    case miss
    case notChecked
}

// MARK: - CheckinItemViewModel

struct CheckinItemViewModel: Equatable {
    let status: CheckinItemStatus

    init(checkinProgress: CheckinProgress) {
        self.status = {
            if checkinProgress.isCompleted {
                return .checked
            } else {
                return checkinProgress.day < Date() ? .miss : .notChecked
            }
        }()
    }
}

// MARK: - CheckinItemView

struct CheckinItemView: View {
    let model: CheckinItemViewModel?

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        switch model?.status {
        case .checked:
            ImageAssets.icChecked.swiftUIImage
                .resizable()
                .sizeToFit()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .padding(8)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .background(
                    Circle()
                        .foregroundColor(ColorAssets.primaryGreen100.swiftUIColor)
                )
        case .miss:
            ImageAssets.icPoint.swiftUIImage
                .resizable()
                .sizeToFit()
                .saturation(0)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .padding(8)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .background(
                    Circle()
                        .strokeBorder(lineWidth: 1)
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                )
        case .notChecked:
            ImageAssets.icPoint.swiftUIImage
                .resizable()
                .sizeToFit()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .padding(8)
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .background(
                    Circle()
                        .strokeBorder(lineWidth: 1)
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                )
        case .none:
            Spacer()
        }
    }
}
