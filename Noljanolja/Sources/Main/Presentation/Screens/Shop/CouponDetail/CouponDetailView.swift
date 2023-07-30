//
//  CouponDetailView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 13/06/2023.
//
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftUINavigation

// MARK: - CouponDetailView

struct CouponDetailView<ViewModel: CouponDetailViewModel>: View {
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
                        viewModel.displayMyCouponAction.send(model)
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
                    url: URL(string: viewModel.model?.couponImage),
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
                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                .clipped()
            }
            .aspectRatio(1, contentMode: .fill)
            .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                Text(viewModel.model?.couponBrandName ?? "")
                    .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text(viewModel.model?.couponName ?? "")
                    .dynamicFont(.systemFont(ofSize: 22, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                Text("1 shot Arabica Espresso with milk")
                    .dynamicFont(.systemFont(ofSize: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
            }
        }
        .padding(16)
    }

    @ViewBuilder
    private func buildBottomView() -> some View {
        switch viewModel.model?.couponDetailInputType {
        case .coupon: buildPricesView()
        case .myCoupon: buildQRCodeView()
        case .none: EmptyView()
        }
    }

    private func buildPricesView() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Text("Holding points")
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text("\((viewModel.model?.myPoint ?? 0).formatted()) P")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            HStack(spacing: 12) {
                Text("Deduction point")
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text("\((viewModel.model?.couponPrice ?? 0).formatted()) P")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.systemRed100.swiftUIColor)
            }
            HStack(spacing: 12) {
                Text("Remaining points")
                    .dynamicFont(.systemFont(ofSize: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(ColorAssets.neutralDeepGrey.swiftUIColor)
                Text("\((viewModel.model?.remainingPoint ?? 0).formatted()) P")
                    .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                    .foregroundColor(ColorAssets.secondaryYellow400.swiftUIColor)
            }
        }
        .padding(16)
    }

    @ViewBuilder
    private func buildQRCodeView() -> some View {
        if let qrImage = viewModel.model?.couponCodeQRImage {
            VStack(spacing: 8) {
                Image(image: qrImage)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
                    .aspectRatio(1, contentMode: .fit)

                Text("Give this Code to the cashier to get products")
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
        switch viewModel.model?.couponDetailInputType {
        case .coupon:
            Button(
                "Purchase".uppercased(),
                action: {
                    viewModel.buyCouponAction.send()
                }
            )
            .buttonStyle(PrimaryButtonStyle(isEnabled: viewModel.model?.isPurchasable ?? false))
            .disabled(!(viewModel.model?.isPurchasable ?? false))
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .padding(.horizontal, 16)
        case .myCoupon, .none:
            EmptyView()
        }
    }
}

extension CouponDetailView {
    private func buildLoadingView() -> some View {
        LoadingView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(ColorAssets.neutralLight.swiftUIColor)
    }

    private func buildEmptyView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func buildErrorView() -> some View {
        Spacer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
