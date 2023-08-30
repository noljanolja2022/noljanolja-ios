//
//  VerticalShareReferralView.swift
//  Noljanolja
//
//  Created by Nguyen The Trinh on 07/08/2023.
//
//

import SwiftUI
import SwiftUIX

// MARK: - VerticalShareReferralView

struct VerticalShareReferralView<ViewModel: VerticalShareReferralViewModel>: View {
    // MARK: Dependencies

    @StateObject var viewModel: ViewModel

    // MARK: State

    @Environment(\.presentationMode) private var presentationMode

    @State private var selectedUsers = [User]()

    private var isCreateConversationEnabled: Bool {
        !selectedUsers.isEmpty
    }

    var body: some View {
        buildBodyView()
            .onAppear { viewModel.isAppearSubject.send(true) }
            .onDisappear { viewModel.isAppearSubject.send(false) }
            .isProgressHUBVisible($viewModel.isProgressHUDShowing)
            .onReceive(viewModel.closeAction) {
                presentationMode.wrappedValue.dismiss()
            }
            .alert(item: $viewModel.alertState) { Alert($0) { _ in } }
    }

    private func buildBodyView() -> some View {
        VStack(spacing: 8) {
            buildNavigationView()
            buildContactView()
            buildButtonView()
        }
        .frame(maxWidth: .infinity)
    }

    private func buildNavigationView() -> some View {
        NavigationBarView(
            centerView: {
                Text(L10n.commonSendTo)
                    .dynamicFont(.systemFont(ofSize: 14))
            },
            trailingView: {
                Button(
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        ImageAssets.icClose.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                            .frame(width: 24, height: 24)
                            .foregroundColor(ColorAssets.neutralDarkGrey.swiftUIColor)
                    }
                )
            }
        )
        .frame(height: 50)
        .padding(.horizontal, 12)
    }

    private func buildContactView() -> some View {
        ContactListView(
            viewModel: ContactListViewModel(
                isMultiSelectionEnabled: true,
                contactListUseCase: ContactListUseCaseImpl()
            ),
            selectedUsers: $selectedUsers,
            selectUserAction: { _ in }
        )
    }

    private func buildButtonView() -> some View {
        Button(
            L10n.commonSend.uppercased(),
            action: {
                withoutAnimation {
                    viewModel.action.send(selectedUsers)
                }
            }
        )
        .buttonStyle(PrimaryButtonStyle())
        .dynamicFont(.systemFont(ofSize: 16, weight: .bold))
        .padding(.horizontal, 16)
    }
}
