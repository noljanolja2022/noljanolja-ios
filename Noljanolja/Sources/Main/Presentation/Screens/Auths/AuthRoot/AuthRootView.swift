//
//  AuthRootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import SwiftUI

// MARK: - AuthRootView

struct AuthRootView<ViewModel: AuthRootViewModel>: View {
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
        case .terms:
            NavigationView {
                TermView(
                    viewModel: TermViewModel(
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        case .auth:
            NavigationView {
                AuthView(
                    viewModel: AuthViewModel(
                        delegate: viewModel
                    )
                )
//                GoogleAuthView(
//                    viewModel: GoogleAuthViewModel(
//                        delegate: viewModel
//                    )
//                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - AuthRootView_Previews

struct AuthRootView_Previews: PreviewProvider {
    static var previews: some View {
        AuthRootView(viewModel: AuthRootViewModel())
    }
}
