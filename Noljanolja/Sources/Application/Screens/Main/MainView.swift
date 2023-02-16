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
        VStack(spacing: 0) {
            TabView(selection: $viewModel.selectedTabItem) {
                ProfileView()
                    .tag(TabBarItem.menu)
                List {
                    ForEach(1...100, id: \.self) {
                        Text("\($0)")
                    }
                }
                .tag(TabBarItem.home)
                Text("2")
                    .tag(TabBarItem.wallet)
                Text("3")
                    .tag(TabBarItem.shop)
                Text("4")
                    .tag(TabBarItem.myPage)
            }
            .introspectTabBarController { tabBarController in
                tabBarController.tabBar.isHidden = true
            }
            TabBarView(
                selection: $viewModel.selectedTabItem,
                items: TabBarItem.allCases
            )
        }
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
