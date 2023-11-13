import SwiftUI
import SwiftUIX

// MARK: - MyGiftView

struct MyGiftView: View {
    // MARK: Dependencies

    @StateObject var viewModel: MyGiftViewModel
    
    var body: some View {
        buildBodyView()
    }

    @ViewBuilder
    private func buildBodyView() -> some View {
        buildMainView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    @ViewBuilder
    private func buildMainView() -> some View {
        ZStack {
            buildNavigationLink()
            buildContentStatefullView()
        }
    }
    
    @ViewBuilder
    private func buildContentStatefullView() -> some View {
        buildContentView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.models.isEmpty },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    @ViewBuilder
    private func buildContentView() -> some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem.flexible(spacing: 12), count: 2)) {
                ForEach(viewModel.models.indices, id: \.self) {
                    let model = viewModel.models[$0]
                    MyGiftItemView(
                        model: model, selectAction: {
                            viewModel.navigationType = .myGiftDetail(model)
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.navigationType = .myGiftDetail(model)
                    }
                }
                
                StatefullFooterView(
                    state: $viewModel.footerState,
                    errorView: EmptyView(),
                    noMoreDataView: EmptyView()
                )
                .onAppear {
                    viewModel.loadMoreAction.send()
                }
            }
            .padding(16)
        }
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

extension MyGiftView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        EmptyView()
    }

    private func buildErrorView() -> some View {
        EmptyView()
    }
}

extension MyGiftView {
    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationLinkDestinationView($0) },
            label: {}
        )
    }

    @ViewBuilder
    private func buildNavigationLinkDestinationView(_ type: Binding<MyGiftNavigationType>) -> some View {
        switch type.wrappedValue {
        case let .myGiftDetail(myGift):
            GiftDetailView(
                viewModel: GiftDetailViewModel(
                    giftDetailInputType: .myGift(myGift)
                )
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(_: Binding<MyGiftFullScreenCoverType>) -> some View {}
}

#Preview {
    MyGiftView(
        viewModel: MyGiftViewModel()
    )
}
