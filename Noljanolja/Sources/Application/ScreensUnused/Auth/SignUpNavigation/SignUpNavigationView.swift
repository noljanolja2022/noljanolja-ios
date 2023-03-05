//
//  SignUpNavigationView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//
//

import SwiftUI

// MARK: - SignUpNavigationView

struct SignUpNavigationView<ViewModel: SignUpNavigationViewModelType>: View {
    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel = SignUpNavigationViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 8) {
            header
            content
        }
    }

    private var header: some View {
        SignUpStepView(step: $viewModel.step)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 8)
    }

    private var content: some View {
        NavigationView {
            TermsView(
                viewModel: TermsViewModel(delegate: viewModel)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - SignUpNavigationView_Previews

struct SignUpNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpNavigationView()
    }
}
