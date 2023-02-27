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
                Text(viewModel.selectedTabItem.name)
                    .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.selectedTabItem) {
                Text("Chat")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorAssets.background.swiftUIColor)
                    .tag(TabBarItem.chat)
                List {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ColorAssets.background.swiftUIColor)
                .tag(TabBarItem.event)
                Text("Content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorAssets.background.swiftUIColor)
                    .tag(TabBarItem.content)
                Text("Shopping")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(ColorAssets.background.swiftUIColor)
                    .tag(TabBarItem.shopping)
                MyPageView()
                    .tag(TabBarItem.profile)
            }
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
            }
            TabBarView(
                selectionItem: $viewModel.selectedTabItem,
                items: TabBarItem.allCases,
                action: { viewModel.selectedTabItem = $0 }
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
