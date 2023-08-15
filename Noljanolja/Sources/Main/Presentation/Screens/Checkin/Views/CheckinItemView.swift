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
    let date: Date
    let status: CheckinItemStatus

    init(checkinProgress: CheckinProgress) {
        self.date = checkinProgress.day
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
            Text(model?.date.string(withFormat: "d") ?? "")
                .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .background(
                    Circle()
                        .foregroundColor(ColorAssets.neutralRawLightGrey.swiftUIColor)
                )
                .padding(8)
                .background(
                    Circle()
                        .strokeBorder(lineWidth: 1)
                        .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
                )
        case .notChecked:
            Text(model?.date.string(withFormat: "d") ?? "")
                .dynamicFont(.systemFont(ofSize: 12, weight: .bold))
                .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .background(
                    Circle()
                        .foregroundColor(ColorAssets.secondaryYellow200.swiftUIColor)
                )
                .padding(8)
                .background(
                    Circle()
                        .strokeBorder(lineWidth: 1)
                        .foregroundColor(ColorAssets.neutralRawDeepGrey.swiftUIColor)
                )
        case .none:
            Spacer()
        }
    }
}
