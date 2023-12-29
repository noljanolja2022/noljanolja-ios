//
//  SourceLicenseView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 15/05/2023.
//
//

import SwiftUI

// MARK: - SourceLicenseView

struct SourceLicenseView<ViewModel: SourceLicenseViewModel>: View {
    // MARK: Dependencies

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBar(title: "Open source license", backButtonTitle: "", presentationMode: presentationMode, trailing: {})
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
    }

    private func buildMainView() -> some View {
        ZStack {
            VStack(spacing: 16) {
                buildContentView()
                buildAboutUsView()
            }

            buildNavigationLinks()
        }
    }

    private func buildContentView() -> some View {
        ScrollView {
            Text(
                """
                KakaoLink
                Copyright 2014-2018 Kakao Corp.
                Apache License 2.0
                AFNetworking
                Copyright (c) 2011-2016 Alamofire Software Foundation (http://alamofire.org/)
                The MIT License (MIT)
                Bolts
                Copyright (c) 2013-present, Facebook, Inc. All rights reserved.
                BSD License
                couchbase-lite-ios
                Couchbase, Inc. Community Edition License Agreement
                DeviceKit
                Copyright (c) 2015 Dennis Weissmann
                The MIT License (MIT)
                FBSDKCoreKit
                Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
                Facebook License
                FirebaseCore
                Apache License 2.0
                FirebaseMessaging
                Apache License 2.0
                FLAnimatedImage
                Copyright (c) 2014 Flipboard
                """
            )
            .dynamicFont(.systemFont(ofSize: 14))
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .padding(16)
        }
    }

    private func buildAboutUsView() -> some View {
        Button(
            L10n.settingAboutUsTitle.uppercased(),
            action: {
                viewModel.navigationType = .aboutUs
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private func buildNavigationLinks() -> some View {
        ZStack {
            NavigationLink(
                unwrapping: $viewModel.navigationType,
                onNavigate: { _ in },
                destination: {
                    switch $0.wrappedValue {
                    case .aboutUs:
                        AboutUsView(
                            viewModel: AboutUsViewModel()
                        )
                    }
                },
                label: { EmptyView() }
            )
            .isDetailLink(false)
        }
    }
}

// MARK: - SourceLicenseView_Previews

struct SourceLicenseView_Previews: PreviewProvider {
    static var previews: some View {
        SourceLicenseView(viewModel: SourceLicenseViewModel())
    }
}
