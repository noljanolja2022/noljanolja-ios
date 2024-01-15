//
//  FriendNotificationView.swift
//  Noljanolja
//
//  Created by Duy Dinh on 15/01/2024.
//

import SwiftUI

// MARK: - FriendNotificationView

struct FriendNotificationView<ViewModel: FriendNotificationViewModel>: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode

    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBar(title: L10n.commonNotification, backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLinks()
        }
        .navigationBarColor(ColorAssets.primaryGreen200.swiftUIColor)
    }

    private func buildContentView() -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.model.indices, id: \.self) { index in
                    buildSectionView(viewModel.model[index])
                }
                buildStatefullFooterView(viewModel.model[index])
            }
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.model.isEmpty ?? false },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private func buildSectionView() -> some View {
        LazyVStack(spacing: 0) {
            ForEach(section.items.indices, id: \.self) { index in
                let item = section.items[index]
                FriendNotificationItemView(
                    model: item,
                    titleColor: {
                        if colorScheme == .light {
                            return ColorAssets.neutralRawDarkGrey.swiftUIColor
                        } else if index % 2 == 0 {
                            return ColorAssets.neutralRawDarkGrey.swiftUIColor
                        } else {
                            return ColorAssets.neutralRawLightGrey.swiftUIColor
                        }
                    }()
                )
                .background(
                    index % 2 == 0
                        ? ColorAssets.secondaryYellow50.swiftUIColor
                        : ColorAssets.neutralLight.swiftUIColor // TODO: TO enable tap item
                )
                .onTapGesture {
                    viewModel.transactionDetailAction.send(item.id)
                }
            }
        }
    }

    private func buildStatefullFooterView(_: [FriendNotificationSectionModel]) -> some View {
        StatefullFooterView(
            state: $viewModel.footerState,
            errorView: EmptyView(),
            noMoreDataView: EmptyView()
        )
        .onAppear {
            viewModel.loadMoreAction.send()
        }
    }

    private func buildNavigationLinks() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: {
                buildNavigationLinkDestinationView($0)
            },
            label: {
                EmptyView()
            }
        )
    }
}

extension FriendNotificationView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }
}

extension FriendNotificationView {
    @ViewBuilder
    private func buildNavigationLinkDestinationView(
        _ type: Binding<FriendNotificationNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        default:
            break
        }
    }
}

// MARK: - FriendNotificationView_Previews

struct FriendNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        FriendNotificationView(viewModel: FriendNotificationViewModel())
    }
}
