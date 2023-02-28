//
//  MyPageView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 22/02/2023.
//
//

import SwiftUI

// MARK: - MyPageView

struct MyPageView<ViewModel: MyPageViewModelType>: View {
    // MARK: Dependencies

    @StateObject private var viewModel: ViewModel

    // MARK: State

    init(viewModel: ViewModel = MyPageViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .loading: buildLoadingView()
            case let .content(data): buildContentView(data)
            case let .error(error): buildErrorView(error)
            }
        }
        .background(ColorAssets.background.swiftUIColor)
        .onAppear {
            AuthServices.default.getIDTokenResult()
            viewModel.loadDataTrigger.send()
        }
    }

    private func buildContentView(_ data: ProfileModel) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                NavigationLink(
                    destination: {
                        MyInfoView(
                            viewModel: MyInfoViewModel(profileModel: data)
                        )
                    },
                    label: {
                        MyPageItemView(
                            title: L10n.MyPage.hello(data.name ?? ""),
                            titleFont: FontFamily.NotoSans.bold.swiftUIFont(size: 18)
                        )
                    }
                )

                Divider()
                    .background(ColorAssets.forcegroundTertiary.swiftUIColor)

                MyPageItemView(
                    image: ImageAssets.icServiceGuide.image,
                    title: L10n.MyPage.serviceGuide
                )
                .background(ColorAssets.white.swiftUIColor)
                .cornerRadius(8)
                .shadow(
                    color: ColorAssets.black.swiftUIColor.opacity(0.15),
                    radius: 2,
                    y: 2
                )

                Button(
                    action: {
                        viewModel.customerServiceCenterTrigger.send()
                    },
                    label: {
                        MyPageItemView(
                            image: ImageAssets.icCustomerServiceCenter.image,
                            title: L10n.MyPage.customerServiceCenter,
                            subTitle: AppConfigs.App.customerServiceCenter,
                            hasArrowImage: false
                        )
                    }
                )
                .background(ColorAssets.white.swiftUIColor)
                .cornerRadius(8)
                .shadow(
                    color: ColorAssets.black.swiftUIColor.opacity(0.15),
                    radius: 2,
                    y: 2
                )
            }
            .padding(16)
        }
        .background(Color.clear)
        .clipped()
    }

    private func buildLoadingView() -> some View {
        LoadingView()
            .foregroundColor(ColorAssets.forcegroundPrimary.swiftUIColor)
            .background(Color.clear)
    }

    private func buildErrorView(_: Error) -> some View {
        StateView(
            title: "Error",
            description: L10n.Common.Error.message,
            actions: {
                Button("Try again") {
                    viewModel.loadDataTrigger.send()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .font(FontFamily.NotoSans.bold.swiftUIFont(size: 18))
                .foregroundColor(ColorAssets.white.swiftUIColor)
                .background(ColorAssets.red.swiftUIColor)
                .cornerRadius(8)
            }
        )
        .background(Color.clear)
    }
}

// MARK: - MyPageView_Previews

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
