//
//  GiftDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation

// MARK: - GiftDetailView

struct GiftDetailView<ViewModel: GiftDetailViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildContentView()
            .navigationBarTitle("", displayMode: .inline)
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) {
                Alert($0) { action in
                    switch action {
                    case let .viewDetail(model):
                        viewModel.displayMyGiftAction.send(model)
                    case .back:
                        presentationMode.wrappedValue.dismiss()
                    case .none:
                        break
                    }
                }
            }
    }

    private func buildContentView() -> some View {
        buildMainView()
            .statefull(
                state: $viewModel.viewState,
                isEmpty: { viewModel.model == nil },
                loading: buildLoadingView,
                empty: buildEmptyView,
                error: buildErrorView
            )
    }

    private func buildMainView() -> some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 12) {
                    buildInfoView()
                    Spacer()
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                        .background(ColorAssets.neutralLightGrey.swiftUIColor)
                    buildBottomView()
                }
            }
            Spacer()
            buildActionView()
        }
    }

    private func buildInfoView() -> some View {
        VStack(spacing: 16) {
            GeometryReader { geometry in
                WebImage(
                    url: URL(string: viewModel.model?.giftImage),
                    context: [
                        .imageTransformer: SDImageResizingTransformer(
                            size: CGSize(
                                width: geometry.size.width * 3,
                                height: geometry.size.height * 3
                            ),
                            scaleMode: .aspectFill
                        )
                    ]
                )
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
            }
            .aspectRatio(
                //                {
//                    switch viewModel.model?.giftDetailInputType {
//                    case .gift: return 1.0
//                    case .myGift: return 2.0 / 3.0
//                    }
//                }(),
                viewModel.model?.giftDetailInputType.gift != nil ? 1.0 : 2.0 / 3.0,
                contentMode: .fill
            )
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)

            VStack(spacing: 8) {
                Text(viewModel.model?.giftBrandName ?? "")
                    .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text(viewModel.model?.giftName ?? "")
                    .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text(viewModel.model?.giftDescription ?? "")
                    .dynamicFont(.systemFont(ofSize: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
            .padding(16)
        }
    }

    @ViewBuilder
    private func buildBottomView() -> some View {
        switch viewModel.model?.giftDetailInputType {
        case .gift: buildBottomGiftShop()
        case .myGift: buildQRCodeView()
        case .none: EmptyView()
        }
    }

    @ViewBuilder
    private func buildBottomGiftShop() -> some View {
        VStack {
            buildPricesView()

            VStack(spacing: 0) {
                ShopGiftView(
                    viewModel: ShopGiftViewModel(
                        categoryId: viewModel.model?.giftCategory?.id,
                        skipGiftProduct: viewModel.model?.giftDetailInputType.gift,
                        title: L10n.maybeYouLike
                    )
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.bottom, 15)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
        }
    }

    private func buildPricesView() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text(L10n.giftDeductionPoint)
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text("\((viewModel.model?.giftPrice ?? 0).formatted()) C")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.systemRed100.swiftUIColor)
            }
            HStack(spacing: 12) {
                Text(L10n.giftHoldingPoint)
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text("\((viewModel.model?.myCoin ?? 0).formatted()) C")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            HStack(spacing: 12) {
                Text(L10n.giftRemainingPoint)
                    .dynamicFont(.systemFont(ofSize: 18))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text("\((viewModel.model?.remainingCoin ?? 0).formatted()) C")
                    .dynamicFont(.systemFont(ofSize: 18, weight: .bold))
                    .foregroundColor(ColorAssets.secondaryYellow400.swiftUIColor)
            }
        }
        .padding(16)
    }

    @ViewBuilder
    private func buildQRCodeView() -> some View {
        if let qrImage = viewModel.model?.giftCodeQRImage {
            VStack(spacing: 8) {
                Image(image: qrImage)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                    .aspectRatio(1, contentMode: .fit)

                Text(L10n.giftGiveCodeToCashier)
                    .dynamicFont(.systemFont(ofSize: 14, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(ColorAssets.primaryGreen300.swiftUIColor)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
        }
    }

    @ViewBuilder
    private func buildActionView() -> some View {
        switch viewModel.model?.giftDetailInputType {
        case .gift:
            Button(
                L10n.giftPurchase.uppercased(),
                action: {
                    viewModel.buyGiftAction.send()
                }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.model?.isPurchasable ?? false))
            .disabled(!(viewModel.model?.isPurchasable ?? false))
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .padding(.horizontal, 16)
        case .myGift, .none:
            EmptyView()
        }
    }
}

extension GiftDetailView {
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
