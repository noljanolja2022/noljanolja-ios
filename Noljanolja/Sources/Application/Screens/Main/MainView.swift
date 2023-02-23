//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 16/02/2023.
//
//

import SwiftUI

// MARK: - MainView

struct MainView<ViewModel: MainViewModelType>: View {
    // MARK: Dependencies
    
    @StateObject private var viewModel: ViewModel
    
    // MARK: State
    
    init(viewModel: ViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            content
        }
        .fullScreenCover(item: $viewModel.navigationType) { navigationType in
            switch navigationType {
            case .authPopup:
                AuthPopupView(
                    viewModel: AuthPopupViewModel(delegate: viewModel)
                )
            case .auth:
                AuthNavigationView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                switch viewModel.selectedTabItem {
                case .menu:
                    Text("Menu")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                case .home:
                    Text("Home")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                case .wallet:
                    Text("Wallet")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                case .shop:
                    Text("Shop")
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                case .myPage:
                    Text(L10n.myPage)
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.selectedTabItem) {
                Text("Menu")
                    .tag(TabBarItem.menu)
                List {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .tag(TabBarItem.home)
                Text("Wallet")
                    .tag(TabBarItem.wallet)
                Text("Shop")
                    .tag(TabBarItem.shop)
                MyPageView()
                    .tag(TabBarItem.myPage)
            }
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
            }
            TabBarView(
                selectionItem: $viewModel.selectedTabItem,
                items: TabBarItem.allCases,
                action: { viewModel.selectedTabItemTrigger.send($0) }
            )
        }
        .background(ColorAssets.background.swiftUIColor)
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
