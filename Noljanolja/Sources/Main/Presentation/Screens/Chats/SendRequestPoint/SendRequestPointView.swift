//
//  SendRequestPointView.swift
//  Noljanolja
//
//  Created by duydinhv on 03/01/2024.
//

import AlertToast
import SDWebImageSwiftUI
import SwiftUI
import SwiftUIX

// MARK: - SendRequestPointView

struct SendRequestPointView<ViewModel: SendRequestViewModel>: View {
    @StateObject var viewModel: ViewModel

    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var themeManager: AppThemeManager
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?

    var body: some View {
        buildBodyView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .navigationBarHidden(true)
            .navigationBar(
                title: viewModel.type.title,
                backButtonTitle: "",
                presentationMode: presentationMode,
                trailing: {},
                backgroundColor: themeManager.theme.primary200
            )
            .onReceive(viewModel.$fullScreenCoverType) { fullScreenCoverType in
                switch fullScreenCoverType {
                case .popupConfirm:
                    viewControllerHolder?.present(builder: {
                        buildPopupConfirm()
                    })
                case .none:
                    break
                }
            }
            .onReceive(viewModel.$isSuccess) { isSuccess in
                if isSuccess { presentationMode.wrappedValue.dismiss() }
            }
    }

    private func buildBodyView() -> some View {
        VStack {
            ScrollView {
                VStack(spacing: 18) {
                    buildPointView()
                    buildContentView()
                }
                .padding(.top, 12)
                .padding(.horizontal, 16)
            }
            .frame(maxHeight: .infinity)
            .background(themeManager.theme.primary200)

            buildContinueView()
        }
    }

    @ViewBuilder
    private func buildPointView() -> some View {
        WalletMoneyView(
            model: WalletMoneyViewDataModel(
                title: L10n.walletMyPoint,
                titleColorName: ColorAssets.primaryGreen50.name,
                changeString: nil,
                changeColorName: ColorAssets.secondaryYellow200.name,
                iconName: ImageAssets.icPoint.name,
                valueString: viewModel.myPoint?.formatted() ?? "0",
                valueColorName: ColorAssets.secondaryYellow400.name,
                backgroundImageName: ImageAssets.bnPoint.name,
                padding: 16
            )
        )
        .frame(maxWidth: .infinity, maxHeight: 97)
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.2),
            radius: 8,
            x: 0,
            y: 4
        )
    }

    private func buildContentView() -> some View {
        VStack {
            WebImage(
                url: URL(string: viewModel.user.avatar),
                context: [
                    .imageTransformer: SDImageResizingTransformer(
                        size: CGSize(width: 40 * 3, height: 40 * 3),
                        scaleMode: .aspectFill
                    )
                ]
            )
            .resizable()
            .indicator(.activity)
            .scaledToFill()
            .frame(width: 40, height: 40)
            .background(ColorAssets.neutralLightGrey.swiftUIColor)
            .cornerRadius(14)

            Text(
                viewModel.type == .send ? L10n.sendingTo(viewModel.user.name ?? "")
                    : L10n.requestingFrom(viewModel.user.name ?? "")
            )
            .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            .multilineTextAlignment(.center)
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)

            TextField(text: $viewModel.point)
                .keyboardType(.numberPad)
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(ColorAssets.secondaryYellow300.swiftUIColor)
                .cornerRadius(5)
                .padding(.vertical, 10)

            Text(L10n.errorEnoughPoint)
                .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                .foregroundColor(ColorAssets.systemRed100.swiftUIColor)
                .hidden(!viewModel.showError)
        }
        .padding(.vertical, 29)
        .padding(.horizontal, 40)
        .background(ColorAssets.primaryYellow50.swiftUIColor)
        .cornerRadius(18)
    }

    private func buildContinueView() -> some View {
        Button(
            L10n.commonContinue.uppercased(),
            action: {
                viewModel.fullScreenCoverType = .popupConfirm
            }
        )
        .buttonStyle(PrimaryButtonStyle(
            isEnabled: !viewModel.point.isEmpty,
            disabledBackgroundColor: ColorAssets.neutralLightGrey.swiftUIColor
        ))
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
    }

    private func buildPopupConfirm() -> some View {
        VStack(spacing: 18) {
            ImageAssets.bnPopupConfirm.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 178)
                .padding(.bottom, 10)

            if viewModel.type == .send {
                Text(L10n.doYouWantToSend(viewModel.point, viewModel.user.name ?? ""))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .medium))

                Group {
                    Text("This action will subtract ")
                        + Text("-\(viewModel.point)")
                        .foregroundColor(ColorAssets.systemRed100.swiftUIColor)
                        .bold()
                        + Text(" Points in your Wallet.")
                }
                .multilineTextAlignment(.center)
                .dynamicFont(.systemFont(ofSize: 14))
            } else {
                Text(L10n.doYouWantToRequest(viewModel.point, viewModel.user.name ?? ""))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .dynamicFont(.systemFont(ofSize: 16, weight: .medium))

                Text(L10n.willFeedbackYouSoon(viewModel.user.name ?? ""))
                    .multilineTextAlignment(.center)
                    .dynamicFont(.systemFont(ofSize: 14))
            }

            HStack(spacing: 12) {
                Button(
                    viewModel.type == .send ? L10n.commonNo.uppercased() : L10n.shopLater.uppercased(),
                    action: {
                        viewControllerHolder?.dismiss(animated: true)
                    }
                )
                .buttonStyle(PrimaryButtonStyle(
                    enabledBackgroundColor: ColorAssets.neutralLight.swiftUIColor,
                    enabledBorderColor: ColorAssets.primaryGreen200.swiftUIColor
                ))
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))

                Button(
                    L10n.commonYesSure.uppercased(),
                    action: {
                        viewControllerHolder?.dismiss(animated: true, completion: {
                            viewModel.yesAction.send()
                        })
                    }
                )
                .buttonStyle(PrimaryButtonStyle())
                .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
            }
        }
        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
        .padding(.top, 16)
        .padding(.bottom, 34)
        .padding(.horizontal, 14)
        .background(ColorAssets.neutralLight.swiftUIColor)
        .cornerRadius(18)
        .padding(.horizontal, 36)
    }
}
