//
//  LaunchScreenView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 27/02/2023.
//
//

import SwiftUI

// MARK: - LaunchScreenView

struct LaunchScreenView<ViewModel: LaunchScreenViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @EnvironmentObject private var rootViewState: RootViewState

    init(viewModel: ViewModel = LaunchScreenViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            content
            navigationLinks
        }
        .onAppear {
            viewModel.loadDataTrigger.send()
        }
        .onReceive(viewModel.contentTypePublisher) {
            rootViewState.contentType = $0
        }
    }

    var content: some View {
        ZStack(alignment: .bottom) {
            LaunchBackgroundView()
                .ignoresSafeArea()

            if !viewModel.isContinueHidden {
                ZStack {
                    Button(
                        "Continue",
                        action: { viewModel.isShowingTerm = true }
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

    var navigationLinks: some View {
        NavigationLink(
            isActive: $viewModel.isShowingTerm,
            destination: { TermOfServiceView() },
            label: { EmptyView() }
        )
    }
}

// MARK: - LaunchScreenView_Previews

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
