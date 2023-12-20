//
//  AddFriendsHomeView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 03/06/2023.
//
//

import Combine
import SwiftUI
import SwiftUINavigation

// MARK: - AddFriendsHomeView

struct AddFriendsHomeView<ViewModel: AddFriendsHomeViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.addFriendTitle)
                        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
            .fullScreenCover(
                unwrapping: $viewModel.fullScreenCoverType,
                content: {
                    buildFullScreenCoverDestinationView($0)
                }
            )
    }

    private func buildMainView() -> some View {
        ZStack {
            buildContentView()
            buildNavigationLink()
        }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 16) {
            buildSearchPhoneView()
            buildActionView()
            buildQRCodeView()
        }
        .padding(16)
        .ignoresSafeArea(.keyboard)
        .background(ColorAssets.neutralLight.swiftUIColor.ignoresSafeArea())
    }

    private func buildSearchPhoneView() -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(
                    action: {
                        viewModel.fullScreenCoverType = .selectCountry
                    },
                    label: {
                        HStack(spacing: 8) {
                            Text(viewModel.country.flag)
                                .dynamicFont(.systemFont(ofSize: 24))
                                .frame(width: 30, height: 24)
                                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                                .cornerRadius(3)
                            Text(viewModel.country.prefix)
                                .dynamicFont(.systemFont(ofSize: 16))
                            ImageAssets.icArrowRight.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(.pi / 2)
                                .frame(width: 24, height: 24)
                        }
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )

                TextField(
                    L10n.enterPhoneNumber,
                    text: $viewModel.phoneNumberText
                )
                .keyboardType(.phonePad)
                .textFieldStyle(TappableTextFieldStyle())
                .dynamicFont(.systemFont(ofSize: 16))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            }
            .padding(.horizontal, 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(ColorAssets.neutralGrey.swiftUIColor, width: 1, cornerRadius: 8)

            Button(
                action: {
                    viewModel.searchAction.send()
                },
                label: {
                    ImageAssets.icSearch.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .frame(width: 36, height: 36)
                        .foregroundColor(ColorAssets.neutralRawLight.swiftUIColor)
                        .background(
                            viewModel.isDisableSearch
                                ? ColorAssets.neutralLightGrey.swiftUIColor
                                : ColorAssets.primaryGreen200.swiftUIColor
                        )
                        .cornerRadius(18)
                }
            )
            .disabled(viewModel.isDisableSearch)
        }
        .frame(height: 36)
    }

    private func buildActionView() -> some View {
        HStack(spacing: 12) {
            Button(
                action: {
                    viewModel.navigationType = .scan
                },
                label: {
                    VStack(spacing: 12) {
                        ImageAssets.icScan.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text(L10n.scanQrCodeTitle)
                            .dynamicFont(.systemFont(ofSize: 14))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(10)
                }
            )
            .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
            .background(ColorAssets.secondaryYellow50.swiftUIColor)
            .cornerRadius(10)
        }
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
            radius: 6,
            x: 0,
            y: 4
        )
    }

    private func buildQRCodeView() -> some View {
        VStack {
            ZStack(alignment: .topLeading) {
                ImageAssets.bnAddFriendQr.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, -16 * ratioW)

                ImageAssets.icAppMascot.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 214, height: 214)
                    .offset(x: -54, y: -64)

                VStack(spacing: 12) {
                    Group {
                        Text(viewModel.name ?? "")
                            .dynamicFont(.systemFont(ofSize: 14, weight: .bold))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 12)
                        IfLet(
                            $viewModel.qrImage,
                            then: { image in
                                Image(image: image.wrappedValue)
                                    .resizable()
                                    .interpolation(.none)
                            },
                            else: {
                                Spacer()
                            }
                        )
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 172)
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                        .padding(2)
                        .background(ColorAssets.neutralRawLight.swiftUIColor)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)

                    ImageAssets.icPpyy.swiftUIImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 14)

                    Text(L10n.addFriendScanQrToAdd)
                        .dynamicFont(.systemFont(ofSize: 16))
                        .lineLimit(1)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(width: 251, height: 307)
            .background(
                ColorAssets.primaryGreen200.swiftUIColor
                    .cornerRadius(20)
            )
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }

    @ViewBuilder
    private func buildNavigationLink() -> some View {
        NavigationLink(
            unwrapping: $viewModel.navigationType,
            onNavigate: { _ in },
            destination: { buildNavigationDestinationView($0) },
            label: {}
        )
    }
}

extension AddFriendsHomeView {
    @ViewBuilder
    private func buildNavigationDestinationView(
        _ type: Binding<AddFriendsNavigationType>
    ) -> some View {
        switch type.wrappedValue {
        case .scan:
            ScanQRView(
                viewModel: ScanQRViewModel()
            )
        case let .result(users):
            FindUsersResultView(
                viewModel: FindUsersResultViewModel(users: users)
            )
        }
    }

    @ViewBuilder
    private func buildFullScreenCoverDestinationView(
        _ type: Binding<AddFriendsScreenCoverType>
    ) -> some View {
        switch type.wrappedValue {
        case .selectCountry:
            NavigationView {
                SelectCountryView(
                    viewModel: SelectCountryViewModel(
                        selectedCountry: viewModel.country,
                        delegate: viewModel
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

// MARK: - AddFriendsHomeView_Previews

struct AddFriendsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsHomeView(viewModel: AddFriendsHomeViewModel())
    }
}
