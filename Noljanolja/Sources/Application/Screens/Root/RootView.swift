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

    init(viewModel: ViewModel = RootViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        if viewModel.isAuthenticated {
            MainNavigationView()
        } else {
            AuthNavigationView()
        }
    }
}

// MARK: - RootView_Previews

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
