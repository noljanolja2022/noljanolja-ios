//
//  HighlightVideoView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 21/04/2023.
//

import SwiftUI
import SwiftUIX

// MARK: - HighlightVideoView

struct HighlightVideoView: View {
    var videos: [Video]

    @State private var selectedIndex = 0

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedIndex) {
                ForEach(videos.indices, id: \.self) { index in
                    let video = videos[index]
                    HighlightVideoItemView(video: video)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .aspectRatio(CGSize(width: 2, height: 1), contentMode: .fill)

            PageControl(
                numberOfPages: videos.count,
                currentPage: $selectedIndex
            )
            .pageIndicatorTintColor(ColorAssets.neutralGrey.swiftUIColor)
            .currentPageIndicatorTintColor(ColorAssets.primaryMain.swiftUIColor)
        }
    }
}

// MARK: - HighlightVideoView_Previews

struct HighlightVideoView_Previews: PreviewProvider {
    static var previews: some View {
        HighlightVideoView(videos: [])
    }
}
