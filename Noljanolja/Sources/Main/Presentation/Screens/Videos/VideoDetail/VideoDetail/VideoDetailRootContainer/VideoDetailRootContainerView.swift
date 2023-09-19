//
//  VideoDetailRootContainerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/09/2023.
//
//

import SwiftUI

// MARK: - VideoDetailRootContainerView

struct VideoDetailRootContainerView<ContentView: View, ViewModel: VideoDetailRootContainerViewModel>: View {
    // MARK: Dependencies

    let contentView: ContentView
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            contentView
                .padding(.bottom, viewModel.bottomPadding)
        }
    }
}
