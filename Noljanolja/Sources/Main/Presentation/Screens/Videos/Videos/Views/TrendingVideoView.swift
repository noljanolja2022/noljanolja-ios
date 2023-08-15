//
//  TrendingVideoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - TrendingVideoView

struct TrendingVideoView: View {
    var models: [Video]
    var selectAction: ((Video) -> Void)?
    var moreAction: ((Video) -> Void)?

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 16) {
            Text(L10n.videoListToday)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .padding(.horizontal, 16)

            buildContentView()
        }
    }

    private func buildContentView() -> some View {
        LazyVStack(spacing: 24) {
            ForEach(models.indices, id: \.self) { index in
                let model = models[index]
                let itemViewmodel = CommonVideoItemViewModel(model)
                CommonVideoItemView(
                    model: itemViewmodel,
                    elementTypes: [.actionButton, .category, .description],
                    action: {
                        moreAction?(model)
                    }
                )
                .onTapGesture { selectAction?(model) }
            }
        }
        .padding(.bottom, 24)
    }
}

// MARK: - TrendingVideoView_Previews

struct TrendingVideoView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingVideoView(models: [])
    }
}
