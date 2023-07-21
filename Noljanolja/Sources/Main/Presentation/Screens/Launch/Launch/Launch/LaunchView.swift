//
//  LaunchView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import SwiftUI

// MARK: - LaunchView

struct LaunchView<ViewModel: LaunchViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildContentView() -> some View {
        LaunchBackgroundView(
            isButtonHidden: $viewModel.isContinueButtonHidden,
            buttonAction: { viewModel.navigateToAuthAction.send() }
        )
        .ignoresSafeArea()
    }
}

// MARK: - LaunchView_Previews

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(viewModel: LaunchViewModel())
    }
}
