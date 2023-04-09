//
//  MainView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/03/2023.
//
//

import Lottie
import SwiftUI

// MARK: - MainView

struct MainView<ViewModel: MainViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    @State private var isCreateChatShown = false
    @State private var createConversationType: ConversationType?

    init(viewModel: ViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        ZStack {
            buildContentView()
            buildTopView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.state.selectedTab.rawValue)
                    .font(.system(size: 18, weight: .bold))
                    .frame(minWidth: 120)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                switch viewModel.state.selectedTab {
                case .chat:
                    Button(
                        action: { isCreateChatShown.toggle() },
                        label: {
                            ImageAssets.icGroupAdd.swiftUIImage
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
    }

    private func buildContentView() -> some View {
        TabView(selection: $viewModel.state.selectedTab) {
            ConversationListView(
                viewModel: ConversationListViewModel(),
                isCreateChatShown: $isCreateChatShown,
                createConversationType: $createConversationType
            )
            .tag(ViewModel.State.Tab.chat)
            .tabItem {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)

                Text("Chat")
            }

            LottieView(animation: LottieAnimation.named(LottieAssets.underConstruction.name))
                .tag(ViewModel.State.Tab.events)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Events")
                }

            LottieView(animation: LottieAnimation.named(LottieAssets.underConstruction.name))
                .tag(ViewModel.State.Tab.content)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)

                    Text("Content")
                }

            LottieView(animation: LottieAnimation.named(LottieAssets.underConstruction.name))
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

    @ViewBuilder
    private func buildTopView() -> some View {
        if isCreateChatShown {
            ZStack(alignment: .top) {
                HStack {
                    Button(
                        action: {
                            createConversationType = .single
                            isCreateChatShown = false
                        },
                        label: {
                            VStack {
                                ImageAssets.icSingleChat.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 24)

                                Text("Normal Chat")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                            .frame(maxWidth: .infinity)
                        }
                    )
                    Button(
                        action: {
                            createConversationType = .group
                            isCreateChatShown = false
                        },
                        label: {
                            VStack {
                                ImageAssets.icGroupChat.swiftUIImage
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 24)

                                Text("Group Chat")
                                    .font(.system(size: 14))
                            }
                            .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                            .frame(maxWidth: .infinity)
                        }
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(ColorAssets.primaryYellowMain.swiftUIColor)
                .onTapGesture {}

                Text("")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
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
                backgroundColor: ColorAssets.primaryYellowMain.color,
                foregroundColor: ColorAssets.neutralDarkGrey.color
            )
        }
    }
}
