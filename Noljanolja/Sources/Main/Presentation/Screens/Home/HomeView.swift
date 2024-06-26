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
import SwiftUIX

// MARK: - HomeView

struct HomeView<ViewModel: HomeViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel
    @EnvironmentObject var themeManager: AppThemeManager

    // MARK: Private

    private let toolBarActionSubject = PassthroughSubject<MainToolBarActionType?, Never>()

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
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
                        case .watch, .chat:
                            Spacer().background(ColorAssets.neutralLight.swiftUIColor)
                        case .shop, .friends:
                            Spacer()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(themeManager.theme.primary200)
                        case .wallet:
                            VStack {
                                themeManager.theme.primary200
                                    .frame(maxWidth: .infinity, maxHeight: UIScreen.mainHeight * 0.25)
                                    .cornerRadius([.bottomLeading, .bottomTrailing], 40)
                                Spacer()
                            }
                            .background(themeManager.theme == .yellow ? themeManager.theme.primary400 : .clear)
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
        switch tab {
        case .chat:
            ConversationListView(
                viewModel: ConversationListViewModel(
                    delegate: viewModel
                ),
                toolBarAction: toolBarActionSubject.eraseToAnyPublisher()
            )
            .tag(tab)
        case .watch:
            VideosView(
                viewModel: VideosViewModel(
                    delegate: viewModel)
            )
            .tag(tab)
        case .wallet:
            WalletView(
                viewModel: WalletViewModel(
                    delegate: viewModel
                )
            )
            .tag(tab)
        case .shop:
            ShopHomeView(
                viewModel: ShopHomeViewModel(
                    delegate: viewModel)
            )
            .tag(tab)
        case .friends:
            HomeFriendView(
                viewModel: HomeFriendViewModel(
                    delegate: viewModel
                )
            )
            .tag(tab)
        }
    }

    @ViewBuilder
    private func buildTabItemViews() -> some View {
        if viewModel.tabs.contains(.friends) {
            buildTabItemView(.friends)
        }
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
                ? themeManager.theme.primary200
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
        case let .chat(conversationId):
            ChatView(
                viewModel: ChatViewModel(
                    conversationID: conversationId,
                    delegate: viewModel
                )
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
