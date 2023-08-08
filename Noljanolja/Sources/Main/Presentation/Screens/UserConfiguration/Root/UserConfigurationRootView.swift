//
//  UserConfigurationRootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 09/08/2023.
//
//

import SwiftUI

// MARK: - UserConfigurationRootView

struct UserConfigurationRootView<ViewModel: UserConfigurationRootViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        switch viewModel.contentType {
        case .updateCurrentUser:
            UpdateCurrentUserView(
                viewModel: UpdateCurrentUserViewModel(
                    delegate: viewModel
                )
            )
        case .referral:
            AddReferralView(
                viewModel: AddReferralViewModel(
                    delegate: viewModel
                )
            )
        }
    }
}

// MARK: - UserConfigurationRootView_Previews

struct UserConfigurationRootView_Previews: PreviewProvider {
    static var previews: some View {
        UserConfigurationRootView(viewModel: UserConfigurationRootViewModel())
    }
}
