//
//  LaunchRootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import SwiftUI

// MARK: - LaunchRootView

struct LaunchRootView<ViewModel: LaunchRootViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = LaunchRootViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        switch viewModel.state.contentType {
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
        LaunchRootView()
    }
}
