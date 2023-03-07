//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
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
        buildContentView()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.state.selectedTab.rawValue)
                        .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                }
            }
    }

    private func buildContentView() -> some View {
        TabView(selection: $viewModel.state.selectedTab) {
            ConversationListView()
                .tag(ViewModel.State.Tab.chat)
                .tabItem {
                    Image(systemName: "message.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Chat")
                }

            Text("Events")
                .tag(ViewModel.State.Tab.events)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Events")
                }

            Text("Content")
                .tag(ViewModel.State.Tab.content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Content")
                }
            
            Text("Shop")
                .tag(ViewModel.State.Tab.shop)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "cart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Shop")
                }

            ProfileView(
                viewModel: ProfileViewModel(
                    delegate: viewModel
                )
            )
            .tag(ViewModel.State.Tab.profile)
            .tabItem {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                Text("Chat")
            }
        }
        .accentColor(Color.orange)
    }
}

// MARK: - MainView_Previews

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainView()
        }
        .introspectNavigationController { navigationController in
            navigationController.configure(
                backgroundColor: ColorAssets.highlightPrimary.color,
                foregroundColor: ColorAssets.forcegroundPrimary.color
            )
        }
    }
}
