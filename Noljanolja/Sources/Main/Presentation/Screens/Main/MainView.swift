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
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar { buildToolBarContent() }
            .navigationBarHidden(viewModel.selectedTab.isNavigationBarHidden)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
    }

    @ToolbarContentBuilder
    private func buildToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            switch viewModel.selectedTab {
            case .chat:
                Text(viewModel.selectedTab.navigationBarTitle)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
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
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .frame(minWidth: 120)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            switch viewModel.selectedTab {
            case .chat:
                HStack(spacing: 4) {
                    Button(
                        action: {
                            viewModel.navigationType = .addFriends
                        },
                        label: {
                            ImageAssets.icAddPerson.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                        }
                    )

                    Button(
                        action: {},
                        label: {
                            ImageAssets.icSearch.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                        }
                    )

                    Button(
                        action: {
                            toolBarActionSubject.send(.createConversation)
                        },
                        label: {
                            ImageAssets.icChatNew.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(4)
                        }
                    )

                    Button(
                        action: {},
                        label: {
                            ImageAssets.icSettingOutline.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(4)
                        }
                    )
                }
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            case .watch:
                HStack(spacing: 4) {
                    Button(
                        action: {
                            viewModel.navigationType = .searchVideo
                        },
                        label: {
                            ImageAssets.icSearch.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(2)
                        }
                    )
                }
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            case .wallet, .shop, .news:
                EmptyView()
            }
        }
    }

    private func buildContentView() -> some View {
        CustomTabView(
            selection: $viewModel.selectedTab,
            content: buildTabView,
            tabItem: buildTabItemView
        )
    }

    @ViewBuilder
    private func buildTabView() -> some View {
        ConversationListView(
            viewModel: ConversationListViewModel(
                delegate: viewModel
            ),
            toolBarAction: toolBarActionSubject.eraseToAnyPublisher()
        )
        .tag(MainTabType.chat)

        VideosView(
            viewModel: VideosViewModel()
        )
        .tag(MainTabType.watch)

        WalletView(
            viewModel: WalletViewModel(
                delegate: viewModel
            )
        )
        .tag(MainTabType.wallet)

        ShopHomeView(
            viewModel: ShopHomeViewModel()
        )
        .tag(MainTabType.shop)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tag(MainTabType.shop)
    }

    @ViewBuilder
    private func buildTabItemView() -> some View {
        TabItemView(
            imageName: MainTabType.chat.imageName,
            title: MainTabType.chat.tabBarTitle,
            hasNew: viewModel.tabNews[.chat] ?? false,
            action: { viewModel.selectedTab = .chat }
        )
        .foregroundColor(
            viewModel.selectedTab == MainTabType.chat
                ? ColorAssets.primaryGreen200.swiftUIColor
                : ColorAssets.neutralGrey.swiftUIColor
        )

        TabItemView(
            imageName: MainTabType.watch.imageName,
            title: MainTabType.watch.tabBarTitle,
            action: { viewModel.selectedTab = .watch }
        )
        .foregroundColor(
            viewModel.selectedTab == MainTabType.watch
                ? ColorAssets.primaryGreen200.swiftUIColor
                : ColorAssets.neutralGrey.swiftUIColor
        )

        TabItemView(
            imageName: MainTabType.wallet.imageName,
            title: MainTabType.wallet.tabBarTitle,
            action: { viewModel.selectedTab = .wallet }
        )
        .foregroundColor(
            viewModel.selectedTab == MainTabType.wallet
                ? ColorAssets.primaryGreen200.swiftUIColor
                : ColorAssets.neutralGrey.swiftUIColor
        )

        TabItemView(
            imageName: MainTabType.shop.imageName,
            title: MainTabType.shop.tabBarTitle,
            action: { viewModel.selectedTab = .shop }
        )
        .foregroundColor(
            viewModel.selectedTab == MainTabType.shop
                ? ColorAssets.primaryGreen200.swiftUIColor
                : ColorAssets.neutralGrey.swiftUIColor
        )
    }

    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }
}

extension MainView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<MainNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .addFriends:
            AddFriendsHomeView(
                viewModel: AddFriendsHomeViewModel(
                    delegate: viewModel
                )
            )
        case .searchVideo:
            SearchVideosView(
                viewModel: SearchVideosViewModel()
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<MainScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .banners(banners):
            BannersView(viewModel: BannersViewModel(banners: banners))
        }
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