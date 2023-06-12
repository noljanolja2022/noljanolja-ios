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
    
    // MARK: State

    @EnvironmentObject private var progressHUBState: ProgressHUBState

    var body: some View {
        buildBodyView()
    }

    private func buildBodyView() -> some View {
        buildMainView()
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(L10n.addFriendsTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                }
            }
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .onChange(of: viewModel.isProgressHUDShowing) {
                progressHUBState.isLoading = $0
            }
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
        VStack(spacing: 016) {
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
                            Text(viewModel.country.getFlagEmoji())
                                .font(.system(size: 24))
                                .frame(width: 30, height: 24)
                                .background(ColorAssets.neutralLightGrey.swiftUIColor)
                                .cornerRadius(3)
                            Text("+\(viewModel.country.phoneCode)")
                                .font(.system(size: 16))
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
                    L10n.addFriendsSearchPhoneHint,
                    text: $viewModel.phoneNumberText
                )
                .keyboardType(.phonePad)
                .textFieldStyle(TappableTextFieldStyle())
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                .introspectTextField { textField in
                    textField.becomeFirstResponder()
                }
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
                        .background(ColorAssets.primaryGreen200.swiftUIColor)
                        .cornerRadius(18)
                }
            )
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
                        Text(L10n.addFriendsScanQrCode)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(8)
                }
            )
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(12)

            Button(
                action: {
                    viewModel.navigationType = .contactList
                },
                label: {
                    VStack(spacing: 12) {
                        ImageAssets.icContactCalendar.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text(L10n.addFriendsAddByContactTitle)
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                    }
                    .padding(8)
                }
            )
            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
            .background(ColorAssets.neutralLight.swiftUIColor)
            .cornerRadius(12)
        }
        .shadow(
            color: ColorAssets.neutralDarkGrey.swiftUIColor.opacity(0.15),
            radius: 2,
            x: 0,
            y: 2
        )
    }

    private func buildQRCodeView() -> some View {
        ZStack {
            ZStack(alignment: .topLeading) {
                Spacer()
                    .frame(maxWidth: .infinity)
                    .background(ColorAssets.primaryGreen200.swiftUIColor)
                    .cornerRadius(20)
                    .padding(.vertical, 80)

                ImageAssets.bnAddFriendQr.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, -16)

                ImageAssets.icAppMascot.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
                    .padding(.leading, -72)
            }

            VStack(spacing: 12) {
                VStack(spacing: 12) {
                    Text(viewModel.name ?? "")
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)

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
                    .frame(maxWidth: .infinity)
                    .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                    .background(ColorAssets.neutralRawLight.swiftUIColor)
                    .cornerRadius(4)
                }
                .padding(.horizontal, 24)

                ImageAssets.icPpyy.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 14)

                Text(L10n.addFriendsAddByContactDescription)
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
        .padding(.horizontal, 32)
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
        case .contactList:
            AddFriendContactListView(
                viewModel: AddFriendContactListViewModel()
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
