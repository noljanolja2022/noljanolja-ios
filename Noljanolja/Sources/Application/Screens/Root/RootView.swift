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

struct RootView<ViewModel: RootViewModelType>: View {
    // MARK: Dependencies
    
    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = RootViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            switch viewModel.state.contentType {
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
                .introspectNavigationController { navigationController in
                    navigationController.configure(
                        backgroundColor: ColorAssets.highlightPrimary.color,
                        foregroundColor: ColorAssets.forcegroundPrimary.color
                    )
                }
            }
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
