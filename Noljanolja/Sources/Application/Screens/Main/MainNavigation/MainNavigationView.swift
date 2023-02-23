//
//  MainNavigationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 23/02/2023.
//
//

import SwiftUI

// MARK: - MainNavigationView

struct MainNavigationView<ViewModel: MainNavigationViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = MainNavigationViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            MainView()
        }
        .introspectNavigationController { navigationController in
            navigationController.configure(
                backgroundColor: ColorAssets.highlightPrimary.color,
                foregroundColor: ColorAssets.forcegroundPrimary.color
            )
        }
    }
}

// MARK: - MainNavigationView_Previews

struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
