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
        ScrollView {
            VStack(spacing: 16) {
                NavigationLink(
                    destination: {
                        MyInfoView()
                    },
                    label: {
                        MyPageItemView(
                            title: L10n.MyPage.hello("noljanolja"),
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
        .background(ColorAssets.background.swiftUIColor)
        .clipped()
    }
}

// MARK: - MyPageView_Previews

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
