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

    @StateObject private var state = RootViewState()

    init(viewModel: ViewModel = RootViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            switch state.contentType {
            case .launch:
                NavigationView {
                    LaunchScreenView()
                }
            case .main:
                MainNavigationView()
            }
        }
        .environmentObject(state)
        .onReceive(viewModel.isAuthenticatedPublisher) {
            state.contentType = $0 ? .main : .launch
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
