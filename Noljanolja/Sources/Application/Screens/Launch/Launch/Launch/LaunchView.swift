//
//  LaunchView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import SwiftUI

// MARK: - LaunchView

struct LaunchView<ViewModel: LaunchViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel = LaunchViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildContentView()
            .onAppear { viewModel.send(.loadData) }
    }

    private func buildContentView() -> some View {
        ZStack(alignment: .bottom) {
            LaunchBackgroundView(
                isButtonHidden: $viewModel.state.isContinueButtonHidden,
                buttonAction: { viewModel.send(.didTapContinueButton) }
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - LaunchView_Previews

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
