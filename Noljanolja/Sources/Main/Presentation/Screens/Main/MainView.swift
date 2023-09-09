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
                buildVideoDetailView()
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

    private func buildVideoDetailView() -> some View {
        VideoDetailView(
            viewModel: VideoDetailViewModel(videoId: "mwj-R9EY2GI")
        )
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
