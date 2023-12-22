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
        ZStack(alignment: .bottom) {
            buildHomeContainerView()
            buildVideoDetailView()
        }
        .onAppear {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.backgroundColor = ColorAssets.neutralLight.color
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: ColorAssets.neutralDarkGrey.color
            ]
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        }
    }

    private func buildHomeContainerView() -> some View {
        VStack(spacing: 0) {
            buildContentView()
                .padding(.bottom, viewModel.bottomPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .zIndex(1)
    }

    private func buildContentView() -> some View {
        NavigationView {
            HomeView(
                viewModel: HomeViewModel(
                    delegate: viewModel
                )
            )
            .onAppear {
                viewModel.isHomeAppearSubject.send(true)
            }
            .onDisappear {
                viewModel.isHomeAppearSubject.send(false)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(ColorAssets.neutralDarkGrey.swiftUIColor)
//        .introspectNavigationController { navigationController in
//            navigationController.configure(
//                backgroundColor: ColorAssets.neutralLight.color,
//                foregroundColor: ColorAssets.neutralDarkGrey.color
//            )
//        }
    }

    @ViewBuilder
    private func buildVideoDetailView() -> some View {
        VideoDetailView(
            viewModel: VideoDetailViewModel.shared
        )
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
