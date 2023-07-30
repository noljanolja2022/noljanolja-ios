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
            NavigationView {
                MainView(
                    viewModel: MainViewModel(
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .accentColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .introspectNavigationController { navigationController in
                navigationController.configure(
                    backgroundColor: ColorAssets.primaryGreen200.color,
                    foregroundColor: ColorAssets.neutralDarkGrey.color
                )
            }
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: RootViewModel())
    }
}
