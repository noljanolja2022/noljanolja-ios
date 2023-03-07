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
            LaunchBackgroundView()
                .ignoresSafeArea()

            if !viewModel.state.isContinueButtonHidden {
                ZStack {
                    Button(
                        "Continue",
                        action: {
                            viewModel.send(.didTapContinueButton)
                        }
                    )
                    .buttonStyle(SecondaryButtonStyle())
                    .shadow(
                        color: ColorAssets.black.swiftUIColor.opacity(0.12), radius: 2, y: 1
                    )
                    .background(ColorAssets.white.swiftUIColor)
                    .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 4)
            }
        }
    }
}

// MARK: - LaunchView_Previews

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
