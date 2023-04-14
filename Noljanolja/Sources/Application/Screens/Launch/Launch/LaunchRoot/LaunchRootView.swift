//
//  LaunchRootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import SwiftUI

// MARK: - LaunchRootView

struct LaunchRootView<ViewModel: LaunchRootViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        switch viewModel.contentType {
        case .launch:
            LaunchView(
                viewModel: LaunchViewModel(
                    delegate: viewModel
                )
            )
        case .updateCurrentUser:
            UpdateCurrentUserView(
                viewModel: UpdateCurrentUserViewModel(
                    delegate: viewModel
                )
            )
        }
    }
}

// MARK: - LaunchRootView_Previews

struct LaunchRootView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchRootView(viewModel: LaunchRootViewModel())
    }
}
