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
            .toolbar {
                buildToolBarContent()
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    @ToolbarContentBuilder
    private func buildToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(viewModel.selectedTab.rawValue)
                .font(.system(size: 18, weight: .bold))
                .frame(minWidth: 120)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            switch viewModel.selectedTab {
            case .chat:
                Button(
                    action: {
                        toolBarActionSubject.send(.createConversation)
                    },
                    label: {
                        ImageAssets.icAddChat.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(12)
                    }
                )
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            default:
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
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text("Chat")
            }

            LottieView(animation: LottieAnimation.named(LottieAssets.underConstruction.name))
                .tag(MainTabType.events)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Events")
                }

            LottieView(animation: LottieAnimation.named(LottieAssets.underConstruction.name))
                .tag(MainTabType.content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Content")
                }

            LottieView(animation: LottieAnimation.named(LottieAssets.underConstruction.name))
                .tag(MainTabType.shop)
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
            .tag(MainTabType.profile)
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
            MainView(viewModel: MainViewModel())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .introspectNavigationController { navigationController in
            navigationController.configure(
                backgroundColor: ColorAssets.primaryYellowMain.color,
                foregroundColor: ColorAssets.neutralDarkGrey.color
            )
        }
    }
}
