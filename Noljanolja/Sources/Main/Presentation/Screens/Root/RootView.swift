//
//  RootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI
import UIKit

// MARK: - RootView

struct RootView<ViewModel: RootViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .environmentObject(AppThemeManager.shared)
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        switch viewModel.contentType {
        case .launch:
            LaunchRootView(
                viewModel: LaunchRootViewModel(
                    delegate: viewModel
                )
            )
        case .auth:
            AuthRootView(
                viewModel: AuthRootViewModel(
                    delegate: viewModel
                )
            )
        case .main:
            MainView(
                viewModel: MainViewModel(
                    delegate: viewModel
                )
            )
        case .userConfiguraction:
            UserConfigurationRootView(
                viewModel: UserConfigurationRootViewModel(
                    delegate: viewModel
                )
            )
        case .term:
            TermView(
                viewModel: TermViewModel(
                    delegate: viewModel
                )
            )
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
