//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Combine
import Lottie
import SwiftUI

// MARK: - MainView

struct MainView<ViewModel: MainViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: Private

    private let toolBarActionSubject = PassthroughSubject<MainToolBarActionType?, Never>()

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar { buildToolBarContent() }
            .navigationBarHidden(viewModel.selectedTab.isNavigationBarHidden)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    @ToolbarContentBuilder
    private func buildToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            switch viewModel.selectedTab {
            case .chat:
                Text(viewModel.selectedTab.navigationBarTitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            case .watch, .wallet, .shop, .news:
                EmptyView()
            }
        }

        ToolbarItem(placement: .principal) {
            switch viewModel.selectedTab {
            case .chat:
                EmptyView()
            case .watch, .wallet, .shop, .news:
                Text(viewModel.selectedTab.navigationBarTitle)
                    .font(.system(size: 16, weight: .bold))
                    .frame(minWidth: 120)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            switch viewModel.selectedTab {
            case .chat:
                Button(
                    action: {
                        toolBarActionSubject.send(.createConversation)
                    },
                    label: {
                        ImageAssets.icChatNew.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(12)
                    }
                )
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            case .watch, .wallet, .shop, .news:
                EmptyView()
            }
        }
    }

    private func buildContentView() -> some View {
        TabView(selection: $viewModel.selectedTab) {
            ConversationListView(
                viewModel: ConversationListViewModel(),
                toolBarAction: toolBarActionSubject.eraseToAnyPublisher()
            )
            .tag(MainTabType.chat)
            .tabItem {
                Image(MainTabType.chat.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text(MainTabType.chat.tabBarTitle)
                    .font(.system(size: 10))
            }

            VideosView(
                viewModel: VideosViewModel()
            )
            .tag(MainTabType.watch)
            .tabItem {
                Image(MainTabType.watch.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text(MainTabType.watch.tabBarTitle)
                    .font(.system(size: 10))
            }

            ProfileView(
                viewModel: ProfileViewModel(
                    delegate: viewModel
                )
            )
            .tag(MainTabType.wallet)
            .tabItem {
                Image(MainTabType.wallet.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text(MainTabType.wallet.tabBarTitle)
                    .font(.system(size: 10))
            }

            LottieView(
                animation: LottieAnimation.named(
                    LottieAssets.underConstruction.name
                )
            )
            .tag(MainTabType.shop)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(MainTabType.shop)
            .tabItem {
                Image(MainTabType.shop.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text(MainTabType.shop.tabBarTitle)
                    .font(.system(size: 10))
            }

            LottieView(
                animation: LottieAnimation.named(
                    LottieAssets.underConstruction.name
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(MainTabType.news)
            .tabItem {
                Image(MainTabType.news.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text(MainTabType.news.tabBarTitle)
                    .font(.system(size: 10))
            }
        }
        .accentColor(ColorAssets.primaryGreen200.swiftUIColor)
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView(viewModel: MainViewModel())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .introspectNavigationController { navigationController in
            navigationController.configure(
                backgroundColor: ColorAssets.primaryGreen200.color,
                foregroundColor: ColorAssets.neutralDarkGrey.color
            )
        }
    }
}
