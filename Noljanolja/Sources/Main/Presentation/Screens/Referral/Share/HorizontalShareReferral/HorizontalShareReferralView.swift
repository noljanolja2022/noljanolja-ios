//
//  HorizontalShareReferralView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 05/08/2023.
//
//

import SwiftUI

// MARK: - HorizontalShareReferralView

struct HorizontalShareReferralView<ViewModel: HorizontalShareReferralViewModel>: View {
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
            .onReceive(viewModel.closeAction) {
                presentationMode.wrappedValue.dismiss()
            }
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildContentView() -> some View {
        VStack(spacing: 8) {
            buildNavigationView()
            buildContactView()
        }
        .frame(maxWidth: .infinity)
    }

    private func buildNavigationView() -> some View {
        NavigationBarView(
            centerView: {
                Text(L10n.commonSendTo)
                    .dynamicFont(.systemFont(ofSize: 14))
            }
        )
        .frame(height: 50)
    }

    private func buildContactView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: false,
                isSearchHidden: true,
                axis: .horizontal,
                contactListUseCases: ContactListUseCasesImpl()
            ),
            selectedUsers: .constant([]),
            selectUserAction: {
                viewModel.action.send([$0])
            },
            endingView: {
                Button(
                    action: {
                        viewModel.moreAction.send(())
                    },
                    label: {
                        VStack(spacing: 8) {
                            ImageAssets.icSearch.swiftUIImage
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                                .frame(width: 40, height: 40)
                                .background(ColorAssets.primaryGreen200.swiftUIColor)
                                .cornerRadius(14)
                            Text(L10n.commonNext)
                                .dynamicFont(.systemFont(ofSize: 11, weight: .medium))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(alignment: .center)
                        }
                        .foregroundColor(ColorAssets.neutralRawDarkGrey.swiftUIColor)
                        .padding(16)
                    }
                )
            }
        )
    }
}
