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

// MARK: - HomeView

struct HomeView<ViewModel: HomeViewModel>: View {
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
            .alert(item: $viewModel.alertState) {
                Alert($0) { action in
                    switch action {
                    case .exitApp:
                        exit(0)
                    case .none:
                        break
                    }
                }
            }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    @ToolbarContentBuilder
    private func buildToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            switch viewModel.selectedTab {
            case .chat:
                Text(viewModel.selectedTab.navigationBarTitle)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            case .friends, .watch, .wallet, .shop:
                EmptyView()
            }
        }

        ToolbarItem(placement: .principal) {
            switch viewModel.selectedTab {
            case .chat, .friends:
                EmptyView()
            case .watch, .wallet, .shop:
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
            case .wallet, .shop, .friends:
                EmptyView()
            }
        }
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .background(
            ColorAssets.neutralLight.swiftUIColor
                .ignoresSafeArea()
                .overlay {
                    ZStack(alignment: .top) {
                        switch viewModel.selectedTab {
                        case .watch, .chat, .shop:
                            Spacer().background(ColorAssets.neutralLight.swiftUIColor)
                        case .wallet:
                            ImageAssets.bgWalletHeader.swiftUIImage
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .aspectRatio(1.8, contentMode: .fit)
                                .background(ColorAssets.primaryGreen200.swiftUIColor)
                            Spacer()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .friends:
                            ImageAssets.bgFriendsHeader.swiftUIImage
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .scaledToFit()
                                .zIndex(999)
                            Spacer()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(ColorAssets.primaryGreen50.swiftUIColor)
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                }
        )
    }

    private func buildContentView() -> some View {
        CustomTabView(
            selection: $viewModel.selectedTab,
            content: buildTabViews,
            tabItem: buildTabItemViews
        )
    }

    @ViewBuilder
    private func buildTabViews() -> some View {
        if viewModel.tabs.contains(.chat) {
            buildTabView(.chat)
        }
        if viewModel.tabs.contains(.watch) {
            buildTabView(.watch)
        }
        if viewModel.tabs.contains(.wallet) {
            buildTabView(.wallet)
        }
        if viewModel.tabs.contains(.shop) {
            buildTabView(.shop)
        }
        if viewModel.tabs.contains(.friends) {
            buildTabView(.friends)
        }
    }

    @ViewBuilder
    private func buildTabView(_ tab: HomeTabType) -> some View {
        VideoDetailRootContainerView(
            content: {
                switch tab {
                case .chat:
                    ConversationListView(
                        viewModel: ConversationListViewModel(
                            delegate: viewModel
                        ),
                        toolBarAction: toolBarActionSubject.eraseToAnyPublisher()
                    )
                case .watch:
                    VideosView(
                        viewModel: VideosViewModel()
                    )
                case .wallet:
                    WalletView(
                        viewModel: WalletViewModel(
                            delegate: viewModel
                        )
                    )
                case .shop:
                    ShopHomeView(
                        viewModel: ShopHomeViewModel()
                    )
                case .friends:
                    HomeFriendView(
                        viewModel: HomeFriendViewModel(
                            delegate: viewModel
                        )
                    )
                }
            },
            viewModel: VideoDetailRootContainerViewModel()
        )
        .tag(tab)
    }

    @ViewBuilder
    private func buildTabItemViews() -> some View {
        if viewModel.tabs.contains(.chat) {
            buildTabItemView(.chat)
        }
        if viewModel.tabs.contains(.watch) {
            buildTabItemView(.watch)
        }
        if viewModel.tabs.contains(.wallet) {
            buildTabItemView(.wallet)
        }
        if viewModel.tabs.contains(.shop) {
            buildTabItemView(.shop)
        }
        if viewModel.tabs.contains(.friends) {
            buildTabItemView(.friends)
        }
    }

    @ViewBuilder
    private func buildTabItemView(_ tab: HomeTabType) -> some View {
        TabItemView(
            imageName: tab.imageName,
            title: tab.tabBarTitle,
            action: { viewModel.selectedTab = tab }
        )
        .frame(maxWidth: .infinity)
        .foregroundColor(
            viewModel.selectedTab == tab
                ? ColorAssets.primaryGreen200.swiftUIColor
                : ColorAssets.neutralGrey.swiftUIColor
        )
        .background(ColorAssets.neutralLight.swiftUIColor)
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

extension HomeView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<HomeNavigationType>
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
        _ type: Binding<HomeScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case let .banners(banners):
            BannersView(viewModel: BannersViewModel(banners: banners))
        case .notificationSetting:
            NotificationSettingView(
                viewModel: NotificationSettingViewModel()
            )
            .introspectViewController { viewController in
                viewController.view.backgroundColor = .clear
            }
        }
    }
}

// MARK: - HomeView_Previews

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(viewModel: HomeViewModel())
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
