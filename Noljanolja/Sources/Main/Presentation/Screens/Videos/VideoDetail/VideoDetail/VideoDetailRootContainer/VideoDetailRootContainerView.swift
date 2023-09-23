//
//  VideoDetailRootContainerView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/09/2023.
//
//

import SwiftUI

// MARK: - VideoDetailRootContainerView

struct VideoDetailRootContainerView<Content, ViewModel>: View where Content: View, ViewModel: VideoDetailRootContainerViewModel {
    // MARK: Dependencies

    private let content: Content
    @StateObject private var viewModel: ViewModel

    init(@ViewBuilder content: () -> Content,
         viewModel: ViewModel) {
        self.content = content()
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            content
                .padding(.bottom, viewModel.bottomPadding)
        }
    }
}
