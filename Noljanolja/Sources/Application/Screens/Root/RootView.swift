//
//  RootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 08/02/2023.
//
//

import SwiftUI

// MARK: - RootView

struct RootView: View {
    @StateObject private var viewModel: RootViewModel

    init(viewModel: RootViewModel = RootViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        if viewModel.isAuthenticated {
            MainView()
                .progress(active: $viewModel.isLoading)
        } else {
            AuthNavigationView()
                .progress(active: $viewModel.isLoading)
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
