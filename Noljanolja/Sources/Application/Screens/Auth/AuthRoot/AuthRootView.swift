//
//  AuthRootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import SwiftUI

// MARK: - AuthRootView

struct AuthRootView<ViewModel: AuthRootViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @StateObject private var progressHUBState = ProgressHUBState()

    init(viewModel: ViewModel = AuthRootViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .progressHUB(isActive: $progressHUBState.isLoading)
            .environmentObject(progressHUBState)
    }

    private func buildContentView() -> some View {
        ZStack {
            switch viewModel.state.contentType {
            case .terms:
                NavigationView {
                    TermOfServiceView(
                        viewModel: TermOfServiceViewModel(
                            delegate: viewModel
                        )
                    )
                }
            case .auth:
                NavigationView {
                    AuthWithPhoneView(
                        viewModel: AuthWithPhoneViewModel(
                            delegate: viewModel
                        )
                    )
                }
            case .updateCurrentUser:
                UpdateCurrentUserView(
                    viewModel: UpdateCurrentUserViewModel(
                        delegate: viewModel
                    )
                )
            }
        }
    }
}

// MARK: - AuthRootView_Previews

struct AuthRootView_Previews: PreviewProvider {
    static var previews: some View {
        AuthRootView()
    }
}
