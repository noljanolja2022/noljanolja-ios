//
//  SignUpRootView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 10/02/2023.
//
//

import SwiftUI

// MARK: - SignUpRootView

struct SignUpRootView: View {
    @StateObject private var viewModel: SignUpRootViewModel

    @Binding private var termAndCoditionItemType: TermAndCoditionItemType?

    init(viewModel: SignUpRootViewModel = SignUpRootViewModel(),
         termAndCoditionItemType: Binding<TermAndCoditionItemType?>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _termAndCoditionItemType = termAndCoditionItemType
    }

    var body: some View {
        VStack(spacing: 8) {
            header
            content
        }
    }

    private var header: some View {
        SignUpStepHeaderView(step: $viewModel.step)
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 8)
    }

    private var content: some View {
        NavigationView {
            TermAndConditionView(
                viewModel: TermAndConditionViewModel(
                    signUpStep: $viewModel.step
                ),
                termAndCoditionItemType: $termAndCoditionItemType
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - SignUpRootView_Previews

struct SignUpRootView_Previews: PreviewProvider {
    @State private static var termAndCoditionItemType: TermAndCoditionItemType? = nil

    static var previews: some View {
        SignUpRootView(termAndCoditionItemType: $termAndCoditionItemType)
    }
}

// MARK: - AuthView_Previews1

struct AuthView_Previews1: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
