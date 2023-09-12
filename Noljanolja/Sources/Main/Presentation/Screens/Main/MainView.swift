//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 06/09/2023.
//
//

import SwiftUI

// MARK: - MainView

struct MainView<ViewModel: MainViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        buildContentView()
            .overlay(alignment: .bottom) {
                buildOverlayView()
            }
    }

    private func buildContentView() -> some View {
        NavigationView {
            HomeView(
                viewModel: HomeViewModel(
                    delegate: viewModel
                )
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        .introspectNavigationController { navigationController in
            navigationController.configure(
                backgroundColor: ColorAssets.primaryGreen200.color,
                foregroundColor: ColorAssets.neutralDarkGrey.color
            )
        }
    }

    @ViewBuilder
    private func buildOverlayView() -> some View {
        if let videoId = viewModel.videoId {
            VideoDetailView(
                viewModel: VideoDetailViewModel(videoId: videoId)
            )
        }
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
