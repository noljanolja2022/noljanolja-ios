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
                ForEach(viewModel.models.indices, id: \.self) { index in
                    buildSectionView(viewModel.models[index])
                }
                buildStatefullFooterView(viewModel.models)
            }
        }
        .statefull(
            state: $viewModel.viewState,
            isEmpty: { viewModel.models.isEmpty },
            loading: buildLoadingView,
            empty: buildEmptyView,
            error: buildErrorView
        )
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private func buildSectionView(_ section: FriendNotificationSectionModel) -> some View {
        LazyVStack(alignment: .leading, spacing: 5) {
            Text(section.header.rawValue)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .font(Font.system(size: 16, weight: .bold))
                .padding(.leading, 16)

            ForEach(section.items.indices, id: \.self) { index in
                let item = section.items[index]
                FriendNotificationItemView(
                    model: item
                )
                .background(
                    index % 2 == 0
                        ? ColorAssets.secondaryYellow50.swiftUIColor
                        : ColorAssets.lightBlue.swiftUIColor
                )
                .onTapGesture {
//                    viewModel.transactionDetailAction.send(item.id)
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
            EmptyView()
        }
    }
}
